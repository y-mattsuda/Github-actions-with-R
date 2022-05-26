import argparse
import os

from dotenv import load_dotenv
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
from slack_sdk.web import SlackResponse

load_dotenv(override=True)

SLACK_BOT_TOKEN = os.getenv("SLACK_BOT_TOKEN")
SLACK_TEST_CH_ID = os.getenv("SLACK_TEST_CH_ID")


def parser() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("filepath", help="Slackへ送信するファイルのパス")
    args = parser.parse_args()
    return args


def main() -> SlackResponse:
    filepath = parser().filepath
    try:
        response = WebClient(token=SLACK_BOT_TOKEN).files_upload(file=filepath, channels=SLACK_TEST_CH_ID)
        return response
    except SlackApiError as e:
        return e.response


if __name__ == "__main__":
    main()
