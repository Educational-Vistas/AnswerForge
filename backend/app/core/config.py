from __future__ import annotations

import urllib.parse
from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    app_name: str = "AnswerForge"
    app_version: str = "0.1.0"
    debug: bool = False

    database_url: str = ""
    openrouter_api_key: str | None = None
    cors_origins: str = "http://localhost:3000"

    @property
    def sqlalchemy_database_uri(self) -> str:
        """Convert .NET-style connection string to SQLAlchemy URI."""
        if not self.database_url:
            raise ValueError("DATABASE_URL is not set")

        params = {}
        for pair in self.database_url.split(";"):
            if "=" in pair:
                key, value = pair.split("=", 1)
                params[key.strip().lower()] = value.strip()

        server = params.get("server", "localhost")
        database = params.get("database", "AnswerForge")
        uid = params.get("uid", "")
        pwd = params.get("pwd", "")

        # Handle server with port (e.g., sql02.edvistas.local,51433)
        host = server
        port = 1433
        if "," in server:
            host, port_str = server.rsplit(",", 1)
            port = int(port_str)

        driver = "ODBC+Driver+17+for+SQL+Server"
        uri = f"mssql+pyodbc://{uid}:{urllib.parse.quote(pwd)}@{host}:{port}/{database}?driver={driver}"

        return uri

    @property
    def cors_origin_list(self) -> list[str]:
        return [origin.strip() for origin in self.cors_origins.split(",")]


@lru_cache
def get_settings() -> Settings:
    return Settings()
