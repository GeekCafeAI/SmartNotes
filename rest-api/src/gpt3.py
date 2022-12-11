from datetime import datetime
import openai

from typing import TypedDict, Optional


INITIAL_PROMPT_PLACEHOLDER = ("I will give you a sentence using which you need to generate 1-3 tags useful for "
                              "categorizing it in a calendar or a to-do list. Tags should be comma-separated. If you "
                              "found a date, output the date in 'year-month-day hour:minutes' format after a newline. "
                              "The sentence: {sentence}")
PROCESSING_TAGS_PLACEHOLDERS = [
    "I will give you comma-separated tags, check if some of them are synonymous and return new comma-separated tags "
    "which are more standard and useful for creating calendar events of to-do lists. Tags: {tags}",
]

PROCESSING_MODELS = [
    'text-davinci-003',
]

Response = str


class Record(TypedDict):
    date: Optional[datetime]
    tags: list[str]


def get_response(prompt: str, model: str, temperature: float = 0.0,
                 frequency_penalty: float = 0.0, presence_penalty: float = 0.0,
                 top_p: float = 1.0, max_tokens: int = 64) -> Response:
    response = openai.Completion.create(
        model=model,
        prompt=prompt,
        temperature=temperature,
        max_tokens=max_tokens,
        top_p=top_p,
        frequency_penalty=frequency_penalty,
        presence_penalty=presence_penalty
    )
    return response['choices'][0]['text'].split('\n\n')[1].strip()


def get_initial_response(sentence: str, prompt_placeholder: str, model: str) -> Response:
    prompt = prompt_placeholder.format(sentence=sentence)
    return get_response(prompt, model=model)


def response2tags(response: Response) -> list[str]:
    tags = [x.strip() for x in response.split(',')]  # TODO: rewrite to work with actual responses
    return tags


def tags2input(tags: list[str]) -> str:
    return ', '.join(tags)


def split_tags_from_date(raw_tags: list[str], date_format: str = '%Y-%m-%d %H:%M') -> (list[str], Optional[datetime]):
    last_tag = raw_tags[-1]
    try:
        date = datetime.strptime(last_tag, date_format)
        tags = raw_tags[:-1]
    except ValueError:
        tags = raw_tags
        date = None
    return tags, date


def finalize_tags(raw_tags: list[str], prompt_placeholders: list[str], models: list[str]) -> list[str]:
    tags = raw_tags
    for placeholder, model in zip(prompt_placeholders, models):
        response = get_response(placeholder.format(tags=tags2input(tags)), model=model)
        tags = response2tags(response)
    return [x.lower() for x in tags]


def get_tags_and_date(sentence: str, model: str = 'text-davinci-003') -> Record:
    with open('key.key', 'r') as f:
        openai.api_key = f.read()
    response = get_initial_response(sentence, INITIAL_PROMPT_PLACEHOLDER, model=model)
    raw_tags = response2tags(response)
    raw_tags, date = split_tags_from_date(raw_tags, '%Y-%m-%d %H:%M')
    tags = finalize_tags(raw_tags, PROCESSING_TAGS_PLACEHOLDERS, PROCESSING_MODELS)
    record: Record = {'date': date, 'tags': tags}
    return record
