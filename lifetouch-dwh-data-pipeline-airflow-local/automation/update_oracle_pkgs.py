import os
import re

def find_and_update_files(base_directory):

    pattern = re.compile(r"(?i)from\s+([a-zA-Z0-9_]+)\.")
    report_file = 'updated_files_report.txt'

    updated_files = []

    for root, dirs, files in os.walk(base_directory):
        for file in files:
            if file.startswith("extract") and file.endswith(".sql"):
                file_path = os.path.join(root, file)
                print(f"found file: {file_path}")
            
                with open(file_path, 'r') as f:
                    content = f.read()
                    print(f"Content of {file_path}:\n{content}\n")

                match = pattern.search(content)
                if match:
                    schema_name = match.group(1)
                    print("schema name:", schema_name)
                    updated_content = content.replace(schema_name, '<schema_name>')
                    print('updated content:\n', updated_content)
                    
                    with open(file_path, 'w') as f:
                        f.write(updated_content)
                    updated_files.append(file_path)
                else:
                    print("schema name not found")
                print('\n' + '-'*80 + '\n')

    with open(report_file, 'w') as report:
        for file_path in updated_files:
            report.write(f"Updated file: {file_path}\n")
    
    print(f"Report of updated files written to {report_file}")


base_directory = 'dags'
find_and_update_files(base_directory)
