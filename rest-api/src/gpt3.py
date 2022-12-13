from datetime import datetime
import openai
from dateparser.search import search_dates
from typing import List, Tuple, TypedDict, Optional
from pathlib import Path


PATH_TO_KEY_FILE = Path().resolve() / Path("rest-api", "src", "key.key")

INITIAL_PROMPT_PLACEHOLDER = ("Generate up to 3 categories from a given text. Categories should be comma-separated."
                              "Text that reminds of any event should get 'reminder' category. "
                              "Add a separate category for date there is any mention of it. "
                              "End categories with '###'."
                              "Text: {sentence}")

PROCESSING_TAGS_PLACEHOLDERS = []
PROCESSING_MODELS = []

Response = str
Tags = list[str]


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
    responses = [request['choices'][i]['text'].split('\n\n')[1].strip() for i in range(logprobs)]
    return responses[0]  # TODO: filter responses instead of choosing the first one


def get_initial_response(sentence: str, prompt_placeholder: str, model: str) -> Response:
    prompt = prompt_placeholder.format(sentence=sentence)
    response = get_response(prompt, model=model)
    return response


def response2tags(response: Response) -> Tags:
    tags = [x.strip() for x in response.split(',')]
    return [x for x in tags if x]


def tags2input(tags: Tags) -> str:
    return ', '.join(tags)


def split_tags_from_date(raw_tags: Tags) -> Tuple[Tags, List[datetime]]:
    dates = [search_dates(tag, languages=['en']) for tag in raw_tags]  # TODO: change language by user's preference
    date_tag_ix, parsed_dates = [], []
    for date_i, date in enumerate(dates):
        if date is not None:
            date_tag_ix.append(date_i)
            parsed_dates.append(date[0][1])  # TODO: currently getting 1st date only - get all and try to join them
    tags_wo_dates = [tag for tag_i, tag in enumerate(raw_tags) if tag_i not in date_tag_ix]
    return tags_wo_dates, parsed_dates


def finalize_tags_with_gpt3(raw_tags: Tags, prompt_placeholders: List[str], models: List[str]) -> Tags:
    tags = raw_tags
    for placeholder, model in zip(prompt_placeholders, models):
        response = get_response(placeholder.format(tags=tags2input(tags)), model=model)
        tags = response2tags(response)
    return [x.lower() for x in tags]


def get_tags_and_date(sentence: str, model: str = 'text-davinci-003') -> Record:
    with open(PATH_TO_KEY_FILE, 'r') as f:
        openai.api_key = f.read()
    response = get_initial_response(sentence, INITIAL_PROMPT_PLACEHOLDER, model=model)
    raw_tags = response2tags(response)
    tags, dates = split_tags_from_date(raw_tags)
    date = dates[0] if dates else None  # TODO: remove hardcoded 1st date selection
    tags = finalize_tags_with_gpt3(raw_tags, PROCESSING_TAGS_PLACEHOLDERS, PROCESSING_MODELS)
    record: Record = {'date': date, 'tags': tags}
    return record


if __name__ == "__main__":
    question = input('Enter your text: ')
    answer = get_tags_and_date(question)
    print(answer)
