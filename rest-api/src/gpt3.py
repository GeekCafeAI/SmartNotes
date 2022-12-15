from datetime import datetime
import openai
from dateparser.search import search_dates
from dateparser.date import DateDataParser, DateData
from typing import List, Tuple, TypedDict, Optional, Literal
from pathlib import Path


PATH_TO_KEY_FILE = Path().resolve() / Path("rest-api", "src", "key.key")

INITIAL_PROMPT_PLACEHOLDER = ("Generate up to 3 categories from a given text. Categories should be comma-separated."
                              "Text that reminds of any event should get 'reminder' category. "
                              "Add a separate category for date there is any mention of it. "
                              "End categories with '###'. Text: {sentence}")

PROCESSING_TAGS_PLACEHOLDERS = []
PROCESSING_MODELS = []

DATEPARSER_SETTINGS = {
    'PREFER_DATES_FROM': 'future',
    'PARSERS': ['relative-time', 'absolute-time'],
    'RETURN_TIME_AS_PERIOD': True
}

Response = str
Tags = list[str]
Period = Literal["time", "day", "week", "month", "year"]


class Record(TypedDict):
    date: Optional[datetime]
    tags: List[str]


def get_response(prompt: str, model: str, temperature: float = 0.0, frequency_penalty: float = 0.0,
                 presence_penalty: float = 0.0, top_p: float = 0.0, logprobs: int = 1,
                 max_tokens: int = 64) -> Response:
    request = openai.Completion.create(
        model=model,
        prompt=prompt,
        temperature=temperature,
        max_tokens=max_tokens,
        top_p=top_p,
        frequency_penalty=frequency_penalty,
        presence_penalty=presence_penalty,
        logprobs=logprobs,
        stop='###'
    )
    responses = [request['choices'][i]['text'].strip() for i in range(logprobs)]
    best_response = filter_responses(responses)
    return best_response


def filter_responses(responses: List[Response]) -> Response:
    # TODO: filter responses instead of choosing the first one
    return responses[0]


def get_initial_response(sentence: str, prompt_placeholder: str, model: str) -> Response:
    prompt = prompt_placeholder.format(sentence=sentence)
    response = get_response(prompt, model=model)
    return response


def response2tags(response: Response) -> Tags:
    tags = [x.strip() for x in response.split(',')]
    return [x for x in tags if x]


def tags2input(tags: Tags) -> str:
    return ', '.join(tags)


def select_best_date(dates: List[DateData]) -> datetime:
    priority_list: List[Period] = ['time', 'day', 'week', 'month']
    periods = [date.period for date in dates]
    for priority in priority_list:
        if priority in periods:
            return dates[periods.index(priority)].date_obj
    return dates[0].date_obj  # return first date if filtering did not help


def split_tags_from_date(raw_tags: Tags, language: str) -> Tuple[Tags, Optional[datetime]]:
    ddp = DateDataParser(settings=DATEPARSER_SETTINGS)
    dates = [search_dates(tag, languages=[language], settings=DATEPARSER_SETTINGS) for tag in raw_tags]
    date_tag_ix, parsed_dates = [], []
    for date_i, date in enumerate(dates):
        if date is not None:
            date_tag_ix.append(date_i)
            parsed_date = ddp.get_date_data(date[0][0])  # always get first date from tag
            parsed_dates.append(parsed_date)
    if parsed_dates:
        best_date = select_best_date(parsed_dates) if len(parsed_dates) > 1 else parsed_dates[0].date_obj
    else:
        best_date = None
    tags_wo_dates = [tag for tag_i, tag in enumerate(raw_tags) if tag_i not in date_tag_ix]
    return tags_wo_dates, best_date


def finalize_tags_with_gpt3(raw_tags: Tags, prompt_placeholders: List[str], models: List[str]) -> Tags:
    tags = raw_tags
    for placeholder, model in zip(prompt_placeholders, models):
        response = get_response(placeholder.format(tags=tags2input(tags)), model=model)
        tags = response2tags(response)
    return [x.lower() for x in tags]


def get_tags_and_date(sentence: str, language: str = 'en', prompt_placeholder: str = INITIAL_PROMPT_PLACEHOLDER,
                      model: str = 'text-davinci-003') -> Record:
    if not sentence:
        return {'date': None, 'tags': []}
    with open(PATH_TO_KEY_FILE, 'r') as f:
        openai.api_key = f.read()
    response = get_initial_response(sentence, prompt_placeholder=prompt_placeholder, model=model)
    raw_tags = response2tags(response)
    tags, date = split_tags_from_date(raw_tags, language=language)
    tags = finalize_tags_with_gpt3(raw_tags, PROCESSING_TAGS_PLACEHOLDERS, PROCESSING_MODELS)
    record: Record = {'date': date, 'tags': tags}
    return record


if __name__ == "__main__":

    test_questions = [
        'buy sour cream until monday',
        '1on1 meeting with the boss friday next week',
        'I want to get fit by the end of year',
        'BananaShop project deadline is 12th October',
        'Sasha birthday Nov 20',
        'idea for a new character for my book: guy who never sleeps',
        'Take pills 3 times a day',
        'I felt derealisation just now'
    ]
    prompt = input('Enter prompt with {sentence}: ')
    for question in test_questions:
        print(get_tags_and_date(question, prompt_placeholder=prompt))

    while True:
        question = input('Enter your sentence: ')
        if question == 'stop':
            print('Stopped testing.')
            break
        if question:
            answer = get_tags_and_date(question, prompt_placeholder=prompt)
            print(answer)
