"""Test integrity of DAGs."""
import pytest
from airflow.models import DagBag

# DAG_PATH = os.path.join(os.path.dirname(__file__), "..", "..", "/dags/**")
# DAG_FILES = glob.glob(DAG_PATH)
dag_path = "dags/"
APPROVED_TAGS = {"lifetouch", "air"}


@pytest.fixture
def dagbag():
    return DagBag(dag_folder=dag_path, include_examples=False)


def test_dag_loading(dagbag):
    """
    test if a DAG has no import errors
    """
    for dag_id, dag in dagbag.dags.items():
        msg = f"DAG {dag_id} has import errors:" \
              f" {dagbag.import_errors.get(dag_id)} "
        assert not dagbag.import_errors.get(dag_id), msg


def test_dag_tags(dagbag):
    """
    test if a DAG is tagged and if those TAGs are in the approved list
    """
    for dag_id, dag in dagbag.dags.items():
        assert not set(dag.tags) - APPROVED_TAGS


def test_task_count(dagbag):
    """
    test if a DAG is defined with specific task count
    """
    expected_count = 4
    for dag_id, dag in dagbag.dags.items():
        actual_count = len(dag.tasks)
        test_result = actual_count == expected_count
        msg = f"DAG {dag_id} has {actual_count} task(s), {expected_count} "
        assert test_result, msg
