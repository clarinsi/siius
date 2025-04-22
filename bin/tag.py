"""
Annotate a plain text file
"""

import sys
import os
import fileinput
#import argparse

import classla
from classla.resources.common import DEFAULT_MODEL_DIR
from classla.utils.conll import CoNLL

#pipeline = classla.Pipeline('sl', processors='tokenize,pos,lemma,depparse', tokenize_pretokenized=False, pos_use_lexicon=True)
pipeline = classla.Pipeline('sl', processors='tokenize,pos,lemma', tokenize_pretokenized=False, pos_use_lexicon=True)

lines = sys.stdin.read()
doc = pipeline(lines)
print(doc.to_conll(),end='')
