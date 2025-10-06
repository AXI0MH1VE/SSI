import sys
import json
import argparse
import time
import psutil
import os
import re

class AxiomDynamicLogicModel:
    """
    Axiom Dynamic Logic Model (ADLM) v2.1
    A self-contained, deterministic, procedural AI built from first principles.
    It operates using an in-memory knowledge graph and a set of logic rules.
    """
    def __init__(self, knowledge_base_path=None):
        self._build_knowledge_graph()
        self.knowledge_base = self._load_external_kb(knowledge_base_path)

    def _build_knowledge_graph(self):
        """Defines the internal 'brain' of the model."""
        self.graph = {
            'entities': {
                'deterministic execution': {
                    'is_a': 'a core principle of sovereign computing',
                    'properties': ['verifiable', 'reproducible', 'auditable'],
                    'details': 'It ensures that given the same input, a system will always produce the identical output.'
                },
                'axiom model': {
                    'is_a': 'a local-first, deterministic AI',
                    'properties': ['sovereign', 'hardware-agnostic', 'cpu-native'],
                    'details': 'The ADLM is a procedural model designed for transparency and performance without external dependencies.'
                },
                'rust': {
                    'is_a': 'a systems programming language',
                    'properties': ['memory safety', 'high performance', 'concurrency'],
                    'details': 'It achieves memory safety without a garbage collector through its ownership model.'
                },
                'ssi': {
                    'is_a': 'a model for digital identity',
                    'properties': ['decentralized', 'user-centric', 'verifiable'],
                    'details': 'Self-Sovereign Identity gives individuals full control over their personal data using technologies like DIDs and Verifiable Credentials.'
                }
            },
            'intents': {
                'what_is': ['what is', 'define', 'what\'s'],
                'explain': ['explain', 'describe', 'tell me about'],
                'compare': ['compare', 'vs', 'versus', 'differentiate']
            }
        }

    def _load_external_kb(self, path):
        if path:
            try:
                with open(path, 'r') as f:
                    return json.load(f)
            except (FileNotFoundError, json.JSONDecodeError):
                return []
        return []

    def _parse(self, prompt: str):
        """Normalize and tokenize the prompt."""
        return re.findall(r'\w+', prompt.lower())

    def _recognize_intent_and_entities(self, tokens: list):
        """Identify the primary intent and entities from the prompt."""
        prompt_str = ' '.join(tokens)
        
        # Intent Recognition
        for intent, keywords in self.graph['intents'].items():
            for keyword in keywords:
                if keyword in prompt_str:
                    # Entity Extraction
                    entities_found = [e for e in self.graph['entities'] if e in prompt_str]
                    if entities_found:
                        # Return first intent and all found entities
                        return intent, entities_found
        return None, []

    def _synthesize_response(self, intent: str, entities: list):
        """Generate a response based on the intent and entities."""
        if not intent or not entities:
            return "Your query could not be processed by the ADLM. Please ask about a known topic like 'Rust' or 'SSI'."

        # --- Intent Handling Logic ---
        if intent == 'what_is':
            entity_key = entities[0]
            entity = self.graph['entities'][entity_key]
            return f"{entity_key.capitalize()} is {entity['is_a']}."

        if intent == 'explain':
            entity_key = entities[0]
            entity = self.graph['entities'][entity_key]
            props = ", ".join(entity['properties'])
            return f"{entity_key.capitalize()} is {entity['is_a']}, characterized by properties like {props}. {entity['details']}"

        if intent == 'compare' and len(entities) >= 2:
            e1_key, e2_key = entities[0], entities[1]
            e1 = self.graph['entities'][e1_key]
            e2 = self.graph['entities'][e2_key]
            
            e1_props = set(e1['properties'])
            e2_props = set(e2['properties'])
            
            common = e1_props.intersection(e2_props)
            
            response = f"Comparing {e1_key} and {e2_key}: Both are related to core computing principles. "
            if common:
                response += f"They share common properties such as {', '.join(common)}. "
            else:
                response += f"While both are important, they address different aspects of system design."
            return response
            
        return "The ADLM understood your intent, but could not form a detailed response. Please try rephrasing."

    def generate(self, prompt: str):
        """Public method to run the full ADLM pipeline."""
        tokens = self._parse(prompt)
        intent, entities = self._recognize_intent_and_entities(tokens)
        return self._synthesize_response(intent, entities)

    def find_citations(self, text_to_check: str) -> list:
        """Ground the response against the external knowledge base."""
        if not self.knowledge_base:
            return []
            
        citations = []
        words_to_check = set(self._parse(text_to_check))

        for entry in self.knowledge_base:
            entry_keywords = set(entry.get("keywords", []))
            common_words = words_to_check.intersection(entry_keywords)
            
            if common_words:
                score = len(common_words) / len(entry_keywords) if entry_keywords else 0
                if score > 0.4: # Match threshold
                    citations.append({
                        "source_id": entry.get("id"),
                        "document_title": entry.get("title"),
                        "match_score": round(score, 2)
                    })
        return sorted(citations, key=lambda x: x["source_id"]) # Deterministic output

def main():
    parser = argparse.ArgumentParser(description='Axiom Dynamic Logic Model Handler.')
    parser.add_argument('--prompt', type=str, required=True, help='The prompt for the model.')
    parser.add_argument('--grounding', action='store_true', help='Enable local knowledge base grounding.')
    args = parser.parse_args()

    # --- Performance and Cost Measurement ---
    process = psutil.Process(os.getpid())
    mem_before = process.memory_info().rss
    cpu_time_before = process.cpu_times().user
    
    # --- Model Execution ---
    kb_path = os.path.join(os.path.dirname(__file__), 'knowledge_base.json')
    model = AxiomDynamicLogicModel(knowledge_base_path=kb_path if args.grounding else None)
    
    response_text = model.generate(args.prompt)
    # Use both prompt and response to find the most relevant citations
    citations = model.find_citations(args.prompt + " " + response_text) if args.grounding else []

    # --- Finalize Measurement ---
    cpu_time_after = process.cpu_times().user
    mem_after = process.memory_info().rss
    
    cpu_time_ms = (cpu_time_after - cpu_time_before) * 1000
    peak_memory_mb = (mem_after - mem_before) / (1024 * 1024)

    result = {
        "response": {
            "text": response_text,
            "citations": citations
        },
        "telemetry": {"model_usage": {"model_name": "Axiom-Dynamic-Logic-Model-v2.1"}},
        "cost_summary": {
            "unit": "local_compute",
            "cpu_time_ms": round(cpu_time_ms, 2),
            "peak_memory_mb": round(max(0, peak_memory_mb), 4),
            "details": "Computational cost measured on the host system."
        }
    }
    
    print(json.dumps(result, indent=2))

if __name__ == '__main__':
    main()
