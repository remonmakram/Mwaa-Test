from datetime import datetime


def generate_dynamic_items(num_items):
    items = []

    for i in range(1, num_items + 1):
        schema_name = f"pk{i}"
        table_name = f"raw{i}"
        current_timestamp = datetime.now().strftime(
            "%Y-%m-%d %H:%M:%S"
        )  # Replace with actual timestamp logic

        item = {
            "schema_name": schema_name,
            "table_name": table_name,
            "timestamp_attribute": current_timestamp,
        }

        items.append(item)

    return items
