"""Player churn prediction for SuikaDrop.

Predicts likelihood of player abandoning a session based on gameplay signals:
drop patterns, score progression, idle time, and combo frequency.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Optional


@dataclass
class SessionFeatures:
    """Features extracted from a single gameplay session."""
    drops_count: int
    max_combo: int
    score: int
    duration_seconds: float
    idle_gaps_avg_seconds: float
    merges_count: int
    highest_fruit_tier: int  # 1=cherry, 11=watermelon
    retry_count: int = 0

    @property
    def drops_per_minute(self) -> float:
        if self.duration_seconds <= 0:
            return 0.0
        return self.drops_count / (self.duration_seconds / 60)

    @property
    def merge_ratio(self) -> float:
        if self.drops_count == 0:
            return 0.0
        return self.merges_count / self.drops_count

    @property
    def engagement_score(self) -> float:
        """Composite engagement metric [0, 1]."""
        tier_norm = self.highest_fruit_tier / 11.0
        combo_norm = min(self.max_combo / 10.0, 1.0)
        idle_penalty = 1.0 / (1.0 + self.idle_gaps_avg_seconds / 5.0)
        return (tier_norm * 0.3 + combo_norm * 0.3 + self.merge_ratio * 0.2 + idle_penalty * 0.2)


class ChurnPredictor:
    """Logistic-regression-style churn predictor using handcrafted weights.

    For production, replace with a trained sklearn/CoreML model.
    These weights are calibrated from gameplay heuristics.
    """

    # Feature weights (negative = reduces churn probability)
    WEIGHTS = {
        "engagement_score": -3.5,
        "drops_per_minute": -0.4,
        "idle_gaps_avg": 0.15,
        "retry_count": -0.8,
        "low_score": 1.2,
        "short_session": 1.5,
    }
    BIAS = 0.5

    def predict_churn_probability(self, session: SessionFeatures) -> float:
        """Return churn probability [0, 1]."""
        z = self.BIAS
        z += self.WEIGHTS["engagement_score"] * session.engagement_score
        z += self.WEIGHTS["drops_per_minute"] * min(session.drops_per_minute / 10.0, 1.0)
        z += self.WEIGHTS["idle_gaps_avg"] * min(session.idle_gaps_avg_seconds / 30.0, 1.0)
        z += self.WEIGHTS["retry_count"] * min(session.retry_count / 3.0, 1.0)
        z += self.WEIGHTS["low_score"] * (1.0 if session.score < 500 else 0.0)
        z += self.WEIGHTS["short_session"] * (1.0 if session.duration_seconds < 30 else 0.0)
        return _sigmoid(z)

    def should_intervene(self, session: SessionFeatures, threshold: float = 0.65) -> bool:
        """Whether to show a retention prompt (hint, encouragement, etc.)."""
        return self.predict_churn_probability(session) > threshold

    def suggest_intervention(self, session: SessionFeatures) -> Optional[str]:
        """Suggest a specific intervention based on session patterns."""
        if session.highest_fruit_tier <= 3 and session.drops_count > 15:
            return "show_merge_hint"
        if session.idle_gaps_avg_seconds > 10:
            return "nudge_continue"
        if session.score < 200 and session.duration_seconds > 60:
            return "show_strategy_tip"
        if session.retry_count == 0 and self.predict_churn_probability(session) > 0.5:
            return "offer_retry_incentive"
        return None


def _sigmoid(z: float) -> float:
    return 1.0 / (1.0 + math.exp(-z))
