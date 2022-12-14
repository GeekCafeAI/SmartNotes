import numpy as np
from itertools import chain, permutations
from nltk.corpus import wordnet as wn

from typing import Tuple, List, Optional


Tag = str
Tags = List[Tag]


def tag2synset(tag: Tag) -> Optional[wn.synset]:
    synsets = wn.synsets(tag)
    if synsets:
        return synsets[0]  # TODO: how to choose the best synset instead of first one?
    else:
        return None  # TODO: do something with tags not found in WordNet


def synset2tag(synset: wn.synset) -> Tag:
    tag = synset.lemma_names()[0]  # TODO: is the first lemma always the best lemma?
    return tag


def get_synset_dist_matrix(synsets: List[wn.synset]) -> np.ndarray:
    dist_matrix = np.zeros((len(synsets), len(synsets)))
    for ss_i0, ss_i1 in permutations(range(len(synsets)), r=2):  # path_similarity is not commutative, so permute
        distance = synsets[ss_i0].path_similarity(synsets[ss_i1])
        dist_matrix[ss_i0, ss_i1] = distance
    return dist_matrix


def get_ix_similar_pairs(dist_matrix: np.ndarray, threshold: float) -> List[Tuple[int, int]]:
    return list(np.argwhere(dist_matrix >= threshold))


def combine_synset_pair(synset_pair: Tuple[wn.synset, wn.synset]) -> wn.synset:
    hypernyms = synset_pair[0].lowest_common_hypernyms(synset_pair[1])
    return hypernyms[0]  # TODO: what to do with possible second and more hypernyms?


def process_tags_for_synonyms(tags: Tags, threshold: float) -> Tags:
    synsets = [tag2synset(tag) for tag in tags]
    synsets = [s for s in synsets if s is not None]
    dist_matrix = get_synset_dist_matrix(synsets)
    synset_pair_ix = get_ix_similar_pairs(dist_matrix, threshold=threshold)
    new_synsets = [ss for ss_i, ss in enumerate(synsets) if ss_i not in set(chain(synset_pair_ix))]
    for ss_i0, ss_i1 in synset_pair_ix:
        combined = combine_synset_pair((synsets[ss_i0], synsets[ss_i1]))
        new_synsets.append(combined)
    new_tags = [synset2tag(synset) for synset in new_synsets]
    return new_tags


if __name__ == "__main__":
    from gpt3 import response2tags
    tags_str = input('Enter comma-separated tags: ')
    tags_list = response2tags(tags_str)
    print('Output using several distance thresholds:')
    for test_thresh in [0.1, 0.3, 0.5, 0.7, 0.9]:
        print(f"{test_thresh}: {process_tags_for_synonyms(tags_list, threshold=test_thresh)}")
