"""Tests for DifficultyScorer."""

import numpy as np
import pytest
from difficulty_scorer import DifficultyScorer


@pytest.fixture
def trained_scorer():
    s = DifficultyScorer()
    X, y = s.generate_synthetic_data(500)
    s.fit(X, y)
    return s


def test_score_in_bounds(trained_scorer):
    result = trained_scorer.score({
        "num_fruits": 10, "size_entropy": 2.0,
        "stack_height_ratio": 0.5, "merge_potential": 3, "empty_ratio": 0.4,
    })
    assert 0.0 <= result <= 1.0


def test_harder_board_scores_higher(trained_scorer):
    easy = trained_scorer.score({
        "num_fruits": 3, "size_entropy": 0.5,
        "stack_height_ratio": 0.1, "merge_potential": 5, "empty_ratio": 0.8,
    })
    hard = trained_scorer.score({
        "num_fruits": 18, "size_entropy": 3.0,
        "stack_height_ratio": 0.9, "merge_potential": 0, "empty_ratio": 0.1,
    })
    assert hard > easy


def test_unfitted_raises():
    s = DifficultyScorer()
    with pytest.raises(RuntimeError):
        s.score({"num_fruits": 5})


def test_entropy_empty():
    assert DifficultyScorer.compute_size_entropy([]) == 0.0


def test_entropy_uniform():
    e = DifficultyScorer.compute_size_entropy([10, 10, 10, 10])
    assert abs(e - 2.0) < 0.01  # log2(4) = 2


def test_synthetic_data_shape():
    X, y = DifficultyScorer.generate_synthetic_data(100)
    assert X.shape == (100, 5)
    assert y.shape == (100,)
    assert np.all(y >= 0) and np.all(y <= 1)
