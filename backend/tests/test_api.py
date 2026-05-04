from __future__ import annotations

import pytest
from fastapi.testclient import TestClient

from main import app


client = TestClient(app)


class TestHealthEndpoint:
    def test_health_check_returns_200(self):
        response = client.get("/api/health")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"
        assert data["app"] == "AnswerForge"


class TestDashboardEndpoint:
    def test_dashboard_returns_stats(self):
        response = client.get("/api/dashboard")
        assert response.status_code == 200
        data = response.json()
        assert "total_assessments" in data
        assert "total_responses" in data


class TestAssessmentsEndpoint:
    def test_list_assessments(self):
        response = client.get("/api/assessments")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)

    def test_get_assessment_not_found(self):
        response = client.get("/api/assessments/999999")
        assert response.status_code == 404
