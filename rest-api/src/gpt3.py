from datetime import datetime
import openai
from dateparser.search import search_dates
from typing import List, Tuple, TypedDict, Optional


INITIAL_PROMPT_PLACEHOLDER = ("Generate up to 3 categories from a given text. Categories should be comma-separated."
                              "Text that reminds of any event should get 'reminder' category. "
                              "End categories with '###'."
                              "Text: {sentence}")
PROCESSING_TAGS_PLACEHOLDERS = []

PROCESSING_MODELS = []

Response = str


class Record(TypedDict):
    date: Optional[datetime]
    tags: List[str]


def get_response(prompt: str, model: str, temperature: float = 0.0, frequency_penalty: float = 0.0,
                 presence_penalty: float = 0.0, top_p: float = 0.0, logprobs: int = 1,
                 max_tokens: int = 64) -> Response:
    answer = openai.Completion.create(
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
    responses = [answer['choices'][i]['text'].split('\n\n')[1].strip() for i in range(logprobs)]
    return responses[0]  # TODO: filter responses instead of choosing the first one


def get_initial_response(sentence: str, prompt_placeholder: str, model: str) -> Response:
    prompt = prompt_placeholder.format(sentence=sentence)
    response = get_response(prompt, model=model)
    return response


def response2tags(response: Response) -> List[str]:
    tags = [x.strip() for x in response.split(',')]
    return [x for x in tags if x]


def tags2input(tags: List[str]) -> str:
    return ', '.join(tags)


def split_tags_from_date(response: Response) -> Tuple[str, Optional[datetime]]:
    date = search_dates(response, languages=['en'])  # TODO: change language by user's preference, or auto-detect
    if date is None:
        return response, None
    else:
        # TODO: currently hardcoded to get first date only - get all dates and try to join them
        response_wo_date = response.replace(date[0][0], '')
        return response_wo_date, date[0][1]


def finalize_tags_with_gpt3(raw_tags: List[str], prompt_placeholders: List[str], models: List[str]) -> List[str]:
    tags = raw_tags
    for placeholder, model in zip(prompt_placeholders, models):
        response = get_response(placeholder.format(tags=tags2input(tags)), model=model)
        tags = response2tags(response)
    return [x.lower() for x in tags]


def get_tags_and_date(sentence: str, model: str = 'text-davinci-003') -> Record:
    with open('key.key', 'r') as f:
        openai.api_key = f.read()
    response = get_initial_response(sentence, INITIAL_PROMPT_PLACEHOLDER, model=model)
    response_wo_date, date = split_tags_from_date(response)
    raw_tags = response2tags(response_wo_date)
    tags = finalize_tags_with_gpt3(raw_tags, PROCESSING_TAGS_PLACEHOLDERS, PROCESSING_MODELS)
    record: Record = {'date': date, 'tags': tags}
    return record
