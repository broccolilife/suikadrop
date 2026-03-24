"""
SuikaDrop Difficulty Scorer

Predicts game difficulty based on board state features:
- Number of active fruits
- Size distribution (entropy)
- Stack height ratio
- Merge potential (adjacent same-type count)

Uses a lightweight gradient boosted model that can run server-side
for dynamic difficulty adjustment and leaderboard normalization.
"""

import numpy as np
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.preprocessing import StandardScaler


class DifficultyScorer:
    """Score board difficulty from 0.0 (trivial) to 1.0 (extreme)."""

    FEATURES = ["num_fruits", "size_entropy", "stack_height_ratio", "merge_potential", "empty_ratio"]

    def __init__(self):
        self.model = GradientBoostingRegressor(
            n_estimators=100,
            max_depth=4,
            learning_rate=0.1,
            random_state=42,
        )
        self.scaler = StandardScaler()
        self._fitted = False

    def fit(self, X: np.ndarray, y: np.ndarray):
        """Train on historical board states and difficulty labels."""
        X_scaled = self.scaler.fit_transform(X)
        self.model.fit(X_scaled, y)
        self._fitted = True
        return self

    def score(self, features: dict) -> float:
        """Score a single board state. Returns 0.0-1.0 difficulty."""
        if not self._fitted:
            raise RuntimeError("Model not fitted. Call fit() first.")
        x = np.array([[features.get(f, 0) for f in self.FEATURES]])
        x_scaled = self.scaler.transform(x)
        raw = self.model.predict(x_scaled)[0]
        return float(np.clip(raw, 0.0, 1.0))

    @staticmethod
    def compute_size_entropy(size_counts: list[int]) -> float:
        """Shannon entropy of fruit size distribution."""
        total = sum(size_counts)
        if total == 0:
            return 0.0
        probs = [c / total for c in size_counts if c > 0]
        return -sum(p * np.log2(p) for p in probs)

    @staticmethod
    def generate_synthetic_data(n_samples: int = 1000, seed: int = 42) -> tuple:
        """Generate synthetic training data for bootstrapping."""
        rng = np.random.RandomState(seed)
        X = np.column_stack([
            rng.randint(1, 20, n_samples),           # num_fruits
            rng.uniform(0, 3.5, n_samples),           # size_entropy
            rng.uniform(0, 1, n_samples),             # stack_height_ratio
            rng.randint(0, 8, n_samples),             # merge_potential
            rng.uniform(0, 1, n_samples),             # empty_ratio
        ])
        # Difficulty heuristic: high fruits + high stack + low merges = hard
        y = np.clip(
            0.3 * (X[:, 0] / 20) +
            0.1 * (X[:, 1] / 3.5) +
            0.3 * X[:, 2] +
            -0.2 * (X[:, 3] / 8) +
            -0.1 * X[:, 4] +
            rng.normal(0, 0.05, n_samples),
            0, 1,
        )
        return X, y
