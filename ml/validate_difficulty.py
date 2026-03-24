"""Validate difficulty scorer meets baseline R² and output bounds."""

import sys
import numpy as np
from sklearn.model_selection import cross_val_score
from difficulty_scorer import DifficultyScorer

MIN_R2 = 0.7

scorer = DifficultyScorer()
X, y = scorer.generate_synthetic_data(n_samples=2000)

# Cross-validate
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import GradientBoostingRegressor

pipe = make_pipeline(StandardScaler(), GradientBoostingRegressor(n_estimators=100, max_depth=4, random_state=42))
scores = cross_val_score(pipe, X, y, cv=5, scoring='r2')
mean_r2 = scores.mean()

if mean_r2 < MIN_R2:
    print(f"❌ R² too low: {mean_r2:.3f} < {MIN_R2}")
    sys.exit(1)

# Validate output bounds after fitting
scorer.fit(X, y)
preds = [scorer.score({f: v for f, v in zip(scorer.FEATURES, row)}) for row in X[:100]]
assert all(0 <= p <= 1 for p in preds), "Predictions out of [0, 1] range"

print(f"✅ Difficulty scorer validated — CV R²: {mean_r2:.3f}, all predictions in [0,1]")
