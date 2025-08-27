
try:
    from hyperon import MeTTa
except RuntimeError:
    print("Failed to import MeTTa from hyperon")

metta = MeTTa()


def add_fact(text):
    print(f"Parsing: {text}")
    try:
        atom = metta.parse_single(text)
        metta.space().add_atom(atom)
    except Exception as e:
        print(f"Error parsing: {e}")


def load_metta_file(knowledgeGraph):
    try:
        with open(knowledgeGraph, "r") as file:
            # filter out comments and blank lines
            facts = [line.strip() for line in file if line.strip() and not line.strip().startswith(";")]

        for fact in facts:
            print("Loading fact:", fact)
            add_fact(fact)
        print(f"Loaded {len(facts)} facts.")
    except FileNotFoundError:
        print(f"The file {knowledgeGraph} was not found")


def execute_query(query: str):
    result = metta.run(query)
    cleaned = []
    for r in result:
        text = str(r).replace("(", "").replace(")", "").replace('"', "").strip("[]")

        # Try to split into movie + reason
        if "-" in text:
            title, reason = text.split("-", 1)
            cleaned.append({
                "title": title.strip(),
                "reason": reason.strip()
            })
        else:
            cleaned.append({"title": text.strip(), "reason": ""})
    return cleaned


# Load knowledge base first
load_metta_file("knowledgeGraph.metta")

if __name__ == "__main__":

    # THEN query
    results1 = execute_query("!(recommend user1)")
    results2 = execute_query("!(recommendByDirector user1)")
    results3 = execute_query("!(recommendByCollaboration user1)")
    print(results1, results2, results3)