import json

def clean_inventory():
    with open("data/costume_shop.json", "r+") as f:
        data = json.load(f)

        used_items = {s["item"] for s in data["schedules"]}
        original_count = len(data["wardrobe_items"])

        data["wardrobe_items"] = [
            item for item in data["wardrobe_items"]
            if item["id"] in used_items or item["status"] not in ["archived", "laundry", "needs alterations"]
        ]

        removed = original_count - len(data["wardrobe_items"])
        f.seek(0)
        json.dump(data, f, indent=2)
        f.truncate()

    print(f"🧼 Removed {removed} unused/archived wardrobe items.")

if __name__ == "__main__":
    clean_inventory()

