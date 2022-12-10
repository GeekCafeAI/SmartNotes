import os
import argparse
from datetime import datetime
import openai

from typing import TypedDict, Optional


openai.api_key = os.getenv("OPENAI_API_KEY")


INITIAL_PROMPT_PLACEHOLDER = ("I will give you a sentence using which you need to generate 1-3 tags useful for "
                              "categorizing it in a calendar or a to-do list. Tags should be comma-separated. If you "
                              "found a date, output the date in 'year-month-day hour:minutes' format after a newline. "
                              "The sentence: {sentence}")
PROCESSING_TAGS_PLACEHOLDERS = [
    "I will give you comma-separated tags, check if some of them are synonymous and return new comma-separated tags "
    "which are more standard and useful for creating calendar events of to-do lists. Tags: {tags}",
]

Response = str


class Record(TypedDict):
    date: Optional[datetime]
    tags: list[str]
    input: str


def get_response(prompt: str, model: str = "code-davinci-002", temperature: float = 0.0,
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
    return response


def get_initial_response(sentence: str, prompt_placeholder: str) -> Response:
    prompt = prompt_placeholder.format(sentence=sentence)
    return get_response(prompt)


def response2tags(response: Response) -> list[str]:
    tags = response.split(',')  # TODO: rewrite to work with actual responses
    return tags


def tags2input(tags: list[str]) -> str:
    return ', '.join(tags)


def response2date(response: Response) -> Optional[datetime]:
    date = None  # TODO: detect and extract date in datetime format
    return date


def finalize_tags(raw_tags: list[str], prompt_placeholders: list[str]) -> list[str]:
    tags = raw_tags
    for placeholder in prompt_placeholders:
        response = get_response(placeholder.format(tags2input(tags)))
        tags = response2tags(response)
    return tags


def get_tags_and_date(sentence: str) -> Record:
    response = get_initial_response(sentence, INITIAL_PROMPT_PLACEHOLDER)
    date = response2date(response)
    raw_tags = response2tags(response)
    tags = finalize_tags(raw_tags, PROCESSING_TAGS_PLACEHOLDERS)
    record: Record = {'input': sentence, 'date': date, 'tags': tags}
    return record


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Get tags and date from a sentence using several GPT3 requests.')
    parser.add_argument('-s', '--sentence', required=True, type=str,
                        help='The sentence from which to extract tags.')
    args = parser.parse_args()
    answer = get_tags_and_date(args.sentence)
    print(answer)
