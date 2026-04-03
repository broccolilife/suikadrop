"""Tests for player churn predictor."""

from ml.player_churn_predictor import ChurnPredictor, SessionFeatures


def test_engaged_player_low_churn():
    session = SessionFeatures(
        drops_count=80, max_combo=7, score=5000, duration_seconds=300,
        idle_gaps_avg_seconds=2.0, merges_count=50, highest_fruit_tier=8, retry_count=2,
    )
    prob = ChurnPredictor().predict_churn_probability(session)
    assert prob < 0.3, f"Engaged player should have low churn, got {prob}"


def test_disengaged_player_high_churn():
    session = SessionFeatures(
        drops_count=5, max_combo=0, score=50, duration_seconds=15,
        idle_gaps_avg_seconds=20.0, merges_count=0, highest_fruit_tier=1,
    )
    prob = ChurnPredictor().predict_churn_probability(session)
    assert prob > 0.6, f"Disengaged player should have high churn, got {prob}"


def test_intervention_suggestion():
    session = SessionFeatures(
        drops_count=20, max_combo=1, score=150, duration_seconds=90,
        idle_gaps_avg_seconds=3.0, merges_count=3, highest_fruit_tier=2,
    )
    suggestion = ChurnPredictor().suggest_intervention(session)
    assert suggestion == "show_merge_hint"


def test_probability_bounds():
    for score in [0, 100, 10000]:
        session = SessionFeatures(
            drops_count=10, max_combo=2, score=score, duration_seconds=60,
            idle_gaps_avg_seconds=5.0, merges_count=5, highest_fruit_tier=4,
        )
        prob = ChurnPredictor().predict_churn_probability(session)
        assert 0.0 <= prob <= 1.0
