from datetime import datetime
from pathlib import Path
from typing import List, Optional, Tuple, TypedDict

import openai
from dateparser.search import search_dates
from typing import List, TypedDict, Optional, Tuple
from pathlib import Path


PATH_TO_KEY_FILE = Path().resolve() / Path("rest-api", "src", "key.key")

INITIAL_TAG_PROMPT_PLACEHOLDER = (
    "Generate up to 4 categories from the given text. The categories should be comma-separated and end with '###'. "
    "Add the 'reminder' category for the text that mentions any event in the future. Add the 'idea' category for the "
    "text that describes an idea. Add the 'goal' category for the text that describes a wish or personal goal. For the "
    "text that includes proper nouns, add them as categories, but do not add human names. Do not continue the text or "
    "write duplicated categories, and ignore dates."
    "\nText: I have a meeting with John on January 2nd, 2022.###"
    "\nCategories: reminder, meeting###"
    "\nText: I need to buy tomatoes until Monday.###"
    "\nCategories: groceries, shopping, reminder###"
    "\nText: Learn how to write mobile apps with Flutter and Python###"
    "\nCategories: goal, learning, programming###"
    "\nText: Lila's birthday: December 20.###"
    "\nCategories: birthday###"
    "\nText: {sentence}###\nCategories:)"
)

INITIAL_DATE_PROMPT_PLACEHOLDER = (
    "Find a date in the provided text and output it in year-month-day format. Add the 'recurrent' word after a comma "
    "for the text that includes a recurrent event."
    "\nText: I have a meeting with John on January 2nd, 2022.###"
    "\nCategories: 2022-01-02###"
    "\nText: I need to buy tomatoes until Monday.###"
    "\nCategories: Monday###"
    "\nText: Learn how to write mobile apps with Flutter and Python###"
    "\nCategories:###"
    "\nText: Lila's birthday: December 20.###"
    "\nCategories: recurrent, december 20###"
    "\nText: {sentence}###\nCategories:"
)


PROCESSING_TAGS_PLACEHOLDERS = []
PROCESSING_MODELS = []
DATE_TAGS = ('recurrent',)


DATEPARSER_SETTINGS = {
    'PREFER_DATES_FROM': 'future',
    'PARSERS': ['relative-time', 'absolute-time'],
    'RETURN_TIME_AS_PERIOD': True
}

Response = str
Tags = List[str]


class Record(TypedDict):
    date: Optional[datetime]
    tags: List[str]


def get_response(
    prompt: str,
    model: str,
    temperature: float = 0.0,
    frequency_penalty: float = 0.0,
    presence_penalty: float = 0.0,
    top_p: float = 0.0,
    logprobs: int = 1,
    max_tokens: int = 64,
) -> Response:
    request = openai.Completion.create(
        model=model,
        prompt=prompt,
        temperature=temperature,
        max_tokens=max_tokens,
        top_p=top_p,
        frequency_penalty=frequency_penalty,
        presence_penalty=presence_penalty,
        logprobs=logprobs,
        stop="###",
    )
    responses = [request['choices'][i]['text'].strip() for i in range(logprobs)]
    best_response = filter_responses(responses)
    return best_response


def filter_responses(responses: List[Response]) -> Response:
    # TODO: filter responses instead of choosing the first one
    return responses[0]


def get_initial_response(
    sentence: str, prompt_placeholder: str, model: str
) -> Response:
    prompt = prompt_placeholder.format(sentence=sentence)
    response = get_response(prompt, model=model)
    return response


def response2tags(response: Response) -> Tags:
    tags = [x.strip() for x in response.split(",")]
    return [x for x in tags if x]


def response2date(response: Response, language: str) -> Optional[datetime]:
    parsed_date = search_dates(response, languages=[language])
    if parsed_date is not None:
        return parsed_date[0][1]


def response2date_tags(response: Response, date_tags: Tuple[str] = DATE_TAGS) -> Tags:
    found_date_tags = []
    for tag in date_tags:
        if tag in response:
            found_date_tags.append(tag)
    return found_date_tags


def tags2input(tags: Tags) -> str:
    return ", ".join(tags)


def finalize_tags_with_gpt3(raw_tags: Tags, prompt_placeholders: List[str], models: List[str]) -> Tags:
    tags = raw_tags
    for placeholder, model in zip(prompt_placeholders, models):
        response = get_response(
            placeholder.format(tags=tags2input(tags)), model=model
        )
        tags = response2tags(response)
    return [x.lower() for x in tags]


def get_tags_and_date(sentence: str, language: str = 'en', model: str = 'text-davinci-003',
                      tag_prompt_placeholder: str = INITIAL_TAG_PROMPT_PLACEHOLDER,
                      date_prompt_placeholder: str = INITIAL_DATE_PROMPT_PLACEHOLDER, verbose: bool = False) -> Record:
    if not sentence:
        return {'date': None, 'tags': []}
    with open(PATH_TO_KEY_FILE, 'r') as f:
        openai.api_key = f.read()
    tag_response = get_initial_response(sentence, prompt_placeholder=tag_prompt_placeholder, model=model)
    date_response = get_initial_response(sentence, prompt_placeholder=date_prompt_placeholder, model=model)
    if verbose:
        print('Tags:', tag_response)
        print('Date:', date_response)
    raw_tags = response2tags(tag_response)
    date = response2date(date_response, language=language)
    date_tags = response2date_tags(date_response)
    tags = finalize_tags_with_gpt3(raw_tags + date_tags, PROCESSING_TAGS_PLACEHOLDERS, PROCESSING_MODELS)
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
    for question in test_questions:
        print(question)
        print(get_tags_and_date(question, verbose=True), '\n')

    while True:
        question = input('Enter your sentence: ')
        if question == 'stop':
            print('Stopped testing.')
            break
        if question:
            answer = get_tags_and_date(question, verbose=True)
            print(answer)
