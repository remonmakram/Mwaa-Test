import argparse
import os


def create_folders(pkg_name, source_type):
    # Create Config Folder
    path = f"../../dags/config/{pkg_name}"
    os.makedirs(path, exist_ok=True)

    # Create SQL Folder
    path = f"../../dags/sql/{pkg_name}"
    os.makedirs(path, exist_ok=True)

    # Create oracle_sqls folder
    if source_type == 'oracle':
        path = f"../../oracle_sqls/{pkg_name}"
        os.makedirs(path, exist_ok=True)


def create_config_file(pkg_name, source_type):
    contents = ''
    if source_type == 'mysql':
        with open('templates/mysql_config_file_template.yaml', 'r+') as file:
            contents = file.read()

    elif source_type == 'oracle':
        with open('templates/oracle_config_file_template.yaml', 'r+') as file:
            contents = file.read()

    elif source_type == 'dw':
        with open('templates/dw_config_file_template.yaml', 'r+') as file:
            contents = file.read()
    elif source_type == '99':
        with open('templates/99_config_file_template.yaml', 'r+') as file:
            contents = file.read()

    contents = contents.replace("PKG_NAME", pkg_name)
    file_path = f"../../dags/config/{pkg_name}/{pkg_name}_pipeline_config.yaml"
    with open(file_path, 'w') as file:
        file.write(contents)


def create_dag(pkg_name, source_type):
    contents = ''
    if source_type == 'dw':
        with open('templates/dag_template_dw.py', 'r+') as file:
            contents = file.read()
    elif source_type == '99':
        with open('templates/dag_template_99.py', 'r+') as file:
            contents = file.read()

    else:
        with open('templates/dag_template.py', 'r+') as file:
            contents = file.read()

    contents = contents.replace("PKG_NAME", pkg_name)
    file_path = f"../../dags/{pkg_name}_dag.py"
    with open(file_path, 'w') as file:
        file.write(contents)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('package_name', type=str)
    parser.add_argument('source_type', type=str)
    available_sources = ['mysql', 'dw', 'oracle', '99']
    args = parser.parse_args()
    pkg_name = args.package_name.lower()
    source_type = args.source_type.lower()
    if source_type not in available_sources:
        raise ValueError("Not an available source!")
    else:

        # print(pkg_name)
        create_folders(pkg_name, source_type)
        create_config_file(pkg_name, source_type)
        create_dag(pkg_name, source_type)
