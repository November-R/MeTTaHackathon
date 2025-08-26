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
def load_metta_file(example):
    try:
        with open(example, "r") as file:
            # filter out comments and blank lines
            facts = [line.strip() for line in file if line.strip() and not line.strip().startswith(";")]

        for fact in facts:
            print("Loading fact:", fact)
            add_fact(fact)
        print(f"Loaded {len(facts)} facts.")
    except FileNotFoundError:
        print(f"The file {example} was not found")

def execute_query(query: str):
    result = metta.run(query)
    cleaned = []
    for r in result:
        text = str(r)
        # remove outer brackets and quotes, then join tokens
        text = text.replace("(", "").replace(")", "").replace('"', "")
        parts = text.split()
        cleaned.append(" ".join(parts))
    return cleaned
    
    #return [str(r) for r in result]

# Load knowledge base first
load_metta_file("example.metta")

# THEN query
#results = execute_query("!(recommend user1)")
results = execute_query("!(recommendByDirector user1)")
print(results)
