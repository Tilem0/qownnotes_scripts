import QtQuick 2.0
import QOwnNotesTypes 1.0

QtObject {

    /**
     * This hook is called to get all custom OpenAI-compatible backends.
     *
     * @returns {array} - a list of backend objects
     */
    function openAiBackendsHook() {
        return [
            {
                id: "academiccloud",
                name: "academiccloud",
                baseUrl: "https://chat-ai.academiccloud.de/v1/chat/completions",
                apiKey: "INSERT_KEY",
                models: [
                    "meta-llama-3.1-8b-instruct", "openai-gpt-oss-120b", "meta-llama-3.1-8b-rag",
                    "llama-3.1-sauerkrautlm-70b-instruct", "llama-3.3-70b-instruct", "gemma-3-27b-it",
                    "medgemma-27b-it", "teuken-7b-instruct-research", "mistral-large-instruct",
                    "qwen3-32b", "qwen3-235b-a22b", "qwen2.5-coder-32b-instruct",
                    "codestral-22b", "internvl2.5-8b", "qwen2.5-vl-72b-instruct",
                    "qwq-32b", "deepseek-r1", "e5-mistral-7b-instruct",
                    "multilingual-e5-large-instruct", "qwen3-embedding-4b"
                ]
            }
        ];
    }
}
