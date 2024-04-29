# Python

## Reading and watching



## New Project using Poetry

```bash
python -m pip install poetry
poetry config virtualenvs.in-project true
poetry config virtualenvs.path ./venv/

poetry init
poetry shell
python -m pip install pip --upgrade
python -m pip install poetry --upgrade
python -m poetry add black pytest prospector mypy bandit --group dev
python -m poetry add pyyaml pandas numpy matplot jupyterlab notebook pandasql pathlib pyarrow python-dotenv pygithub openpyxl


# vi pyproject.tom
# python = ">=3.11,<3.13"

```

## Modern Project Setup

<!-- ```shell
conda create --yes -n cloudquery python=3.11
conda activate cloudquery
pip install pip --upgrade
pip install -r requirements.txt

python -m pip install . 
pipx inject hatch hatch-vcs

python -m pip install . # python -m cq_command

pipx install . # cq_command
python -m pip install --editable .
pipx install --editable . # this resolves mod issues. app changes dont require reinstall.  pyproject.toml changes do.
pipx run build # creates a dist/

# upload to the testpypy repo

pipx run twine upload --repository=testpypi dist/*

# install from the testpypy repo

pipx uninstall cq_command
pipx install --index-url=https://test.pypi.org/simple random-wikipedia-article
``` -->

pip does the following when installing from source.

```shell
py -m venv buildenv
buildenv/bin/python -m pip install hatchling
buildenv/bin/python

import hatchling.build
hatchling.build.build_wheel("dist")
'random_wikipedia_article-0.1-py2.py3-none-any.whl'

py -m pip install dist/*.whl
```

## Versioning, Python and Dependency Management

* NO PYTHON 2.x.
    * If we have any of these, please create a set of stories to upgrade.
* 3.10+ preferred.
* Install anaconda
    * `conda create -n python_style_guide python=3.10`
    * `conda activate python_style_guide`
    * `conda env list`
* Include a requirements.txt for all modules and apps.
* Conda preferred.
* In case of no conda, use venv.

## IDE: Vscode

### Use launch.json to provide environment variables for testing and to select the interpreter

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal",
            "cwd": "${fileDirname}",
            "envFile": "${workspaceFolder}/.env",
            "env": {
                "PYTHONPATH": "${workspaceFolder}:${env:PYTHONPATH}",
                "ANSIBLE_SERVICE_ACCOUNT_USERNAME": "<username>",
                "ANSIBLE_SERVICE_ACCOUNT_PASSWORD": "<password>"
            }
        }
    ]
}
```

### Settings.json

```json
    "python.analysis.logLevel": "Trace",
    "python.autoComplete.addBrackets": true,
    "python.analysis.memory.keepLibraryAst": true,
    "python.analysis.memory.keepLibraryLocalVariables": true,
    "python.diagnostics.sourceMapsEnabled": false,
    "problems.showCurrentInStatus": true,
    
    "python.jediEnabled": false,
    "terminal.integrated.rendererType": "dom",
    "python.languageServer": "Pylance",
    "python.formatting.autopep8Args": [
        "--max-line-length=200"
    ],
    "python.analysis.typeCheckingMode": "basic",
    "python.venvFolders": [
        "/Users/micnorman/opt/miniconda3/envs"
    ],
    "python.analysis.extraPaths": [
        "/Users/micnorman/opt/miniconda3/envs/mql3.10/lib/python3.10/site-packages/"
    ],
```

* Select the correct interpreter
    * ![1](python/images/select_interpreter1.png)
    * ![2](python/images/select_interpreter2.png)
    * ![3](python/images/select_interpreter3.png)

## Architecture

* Good architecture will
    * Promote extensibility
    * Manage Dependencies
    * Foster Composability.
    * Promotes Decoupling
    * Allows for testing
* Event Driven Architecture (EDA) is on options

## Patterns

### Creational

* Factory

* Abstract Factory

* Builder

* Prototype

* Singleton

### Behavioral

Patterns that focus on the responsibilities that an object has.

* [Observer](./patterns/behavioral/observer.py) pattern: Watch for changes?  Pubsub?
* One to many relationship.  Publisher/Subject may publish changes from itself from 0 to many subscriber/Observer.
    * Base Publisher/Subject Class
        * self.subscribers[subscriber] -> list[subscriber]
        * self.Register(subscriber) -> Bool; self.subscribers.append(subscriber)
        * self.Deregister(subscriber) -> Bool; self.subscribers.remove(subscriber)
        * self.NotifyAll() -> Bool; [subscriber.notify() for subscriber in self.subscribers]
        * self.Notify([subscriber]) -> Bool; [i.Notify(self.Data) for i in subscriber]
            * Notify a subset of subscriber/observers.  Not required, but nice to have.
        * self.Subscribers() -> list[subscriber]; return self.subscribers
        * self.Data(Any) -> Any
    * Base Subscriber/Observer Class
        * self.Update(publisher, data: Any) -> Bool

* [Command](./patterns/behavioral/command.py) pattern:
* Encapsulates all info needed to perform an action or trigger an event at a later time.
* This info includes at least:
    * method name
    * object owning the method.
    * values for the method parameters.
* Continually build up what is needed.  Then, perform the action.
* Uses terms:
    * Command
    * Receiver
    * Invoker
    * Client
* Command -invokes-> Receiver
* Command <-parameter values- Receiver
* Invoker -invokes-> Command
* Client -creates-> Command
* Client -> Command -> Invoker -> Command -> Receiver -> Command

### Event Driven Architecture (EDA)

* Variations
    * Simple Events
    * Streaming Events
* Respond to Stimuli
* Stimuli is a producer of events.
* Consumers of events are called subscribers and *react* to stimuli.
* Event is a transmission of information from a producer to a consumer.
* Producers and consumers do not know anything about each other, nor should they.

## Coding Process & Style

* Look things up rather than specify them.
* Always use `if __name__ == '__main__':` so you can both execute and import as a module.
* Will a prebuilt decorator do this job?
* Should i build my own decorator?
* In my code, what are my policies and what are my mechanisms.
    * In many cases, mechanism functions and methods will accept policies.  `def recommend_meal(policy: RecommendationPolicy) -> list[Meal]`
* Event Driven Architecture (EDA) is a great way to build a system.

### Itertools

* `itertools` is your friend.
* `itertools.groupby` is a great way to group things.
* `itertools.takewhile` is a great way to take things while a condition is true.
* `itertools.islice` is a great way to take a slice of an iterator.
* `itertools.chain` is a great way to chain iterators together.
* `itertools.tee` is a great way to create multiple iterators from a single iterator.
* `itertools.product` is a great way to create a cartesian product of iterators.
* `itertools.permutations` is a great way to create all permutations of an iterator.
* `itertools.combinations` is a great way to create all combinations of an iterator.
* `itertools.combinations_with_replacement` is a great way to create all combinations of an iterator with replacement.
* `itertools.cycle` is a great way to create an iterator that cycles through an iterator.
* `itertools.repeat` is a great way to create an iterator that repeats an object.
* `itertools.starmap` is a great way to create an iterator that applies a function to an iterator of tuples.
* `itertools.zip_longest` is a great way to create an iterator that zips iterators together, filling in missing values with a default value.

### Separate policy from mechanism

* Some examples

```python
import itertools

RecommendationPolicy(
    meals=get_specials,
    initial_sorting_criteria=get_proximity_to_surplus_ingredients,
    grouping_criteria=get_proximity_to_surplus_ingredients,
    secondary_sorting_criteria=get_proximity_to_last_meal,
    selection_criteria=proximity_greater_than_75_percent,
    desired_number_of_meals=3,
)

def recommend_meal(policy: RecommendationPolicy) -> list[Meal]:
    meals = get_meals()
    sorted_meals = sorted(meals, key=policy.initial_sorting_criteria, reverse=True)
    grouped_meals = itertools.groupby(sorted_meals, key=policy.grouping_criteria)
    _, top_grouped = next(grouped_meals)
    secondary_sorted = sorted(top_grouped, key=policy.secondary_sorting_criteria, reverse=True)
    candidates = itertools.takewhile(policy.selection_criteria, secondary_sorted)
    return list(candidates)[:policy.desired_number_of_meals]
```

### Sorting

```python
sorted(filtered_meals, key=lambda meal: get_proximity(meal, last_meal), reverse=True)
```

### Helpful Prebuilt Decorators

* `@backoff.on_exception(backoff.expo, OperationException, max_tries=5)` Backoff and retry exponentially.
* `@functools.lru_cache(maxsize=128)` Save results of a function.
* `@timeout_decorator.timeout(5)` Timeout a function.
* `from decorators import count_calls; @count_calls` Count the number of times a function is called.
* `from dataclasses import dataclass; @dataclass` Create a dataclass.
* `@contextlib.contextmanager` Create a context manager.
* `@property` Create a property.
* `@click.command()` Click is a great library for building command line apps.

```python
import click

@click.command()
@click.option("--count", default=1, help="Number of greetings.")
@click.option("--name", prompt="Your name", help="The person to greet.")
def hello(count, name):
    """Simple program that greets NAME for a total of COUNT times."""
    for _ in range(count):
        click.echo(f"Hello, {name}!")

if __name__ == '__main__':
    hello()
```

* Wraps

```python
import functools as ft
def my_decorator(f):
    @wraps(f)
    def wrapper(*args, **kwds):
        print('Calling decorated function')
        return f(*args, **kwds)
    return wrapper

@my_decorator
def func(x):
    print(x)
```

* Singleton

```python
def singleton(cls):
    instances = {}
    def wrapper(*args, **kwargs):
        if cls not in instances:
          instances[cls] = cls(*args, **kwargs)
        return instances[cls]
    return wrapper
@singleton
class cls:
    def func(self):
```

### Homemade Decorators

```python
* Decorators are functions that take another function and wrap it.
* Same as above but with decorators.

```python
# separate policy (saying hello) from mechanism (repeating)
from typing import Callable
def repeat(times: int = 1) -> Callable:
    def _repeat(func: Callable):
        @functools.wraps(func)
        def _wrapper(*args, **kwargs):
            for _ in range(times):
                func(*args, **kwargs)
        return _wrapper
    return _repeat

@repeat(times=3)
def say_hello():
    print('hello')

say_hello()
```

```

### No opening and closing of files

* Use a context manager.

```python
x = open('blay', 'wb')
x.writeline('stuff')
x.close()

with open('blah', 'wb') as f:
    f.writeline('sdf')

```

### Looping

* Prefer comprehensions over for loops.
* Prefer generators over list comprehensions.

### Linting

* Use best available linter.
    * autopep8
    * pylint

### Modules and Imports

* All module folders must include a file named `__init__.py`.  This will usually be blank.
* Be as specific as possible with imports.
    * Do not: `from mod_x import *`
    * Do: `from mod_x import x,y,z`

### Errors & Exceptions

* Use exception handling only when you intend to deal with a specific issue.
* Do not catch all exceptions as that will simply hide the errors from you.
* Fail as fast as possible.  For instance, instead of simply accepting a list, take an iterable and convert it:
    * This will cause an immediate type error in the case of a non-iterable argument rather than failing later.

    ```python
    def x(self, iterable: iterable):
        y = list(iterable)
    ```

* If you need to reject infinite generators, call `len(generator)`.

#### Retry logic

```python
import backoff
import requests
from typing import Callable

@backoff.on_exception(backoff.expo, OperationException, max_tries=5)
@backoff.on_exception(backoff.expo, requests.exceptions.HTTPError, max_times=5)
def do_a_thing(f: Callable):
    f.write_to_db()
```

### Global Variables

* Avoid at all costs.
    * Create constants.
    * Pass into functions.
    * Create a config object and pass that in.

### Typing

* Always use type hints.
* When using functions as args, use callable for type hints.

    ```python
    def filter_list(l: List[int], condition: Callable[[int], bool]) -> List[int]:
    return [i for i in l if condition(i)]

    # Same using an alias
    ConditionFunction = Callable[[int], bool]
    def filter_list(l: List[int], condition: ConditionFunction) -> List[int]:
        return [i for i in l if condition(i)]
    ```

* Type names should use camel case.
* Alias types when relevent.
    * Use

      ```python
      from typing import List, Union, Tuple
      
      InstStringFloatTuple = Tuple[int, str, float]
      t: InstStringFloatTuple = (1, "hello", 3.14)
      ```

### Prefer unpacking when json keys line up with object attributes

```python
from dataclasses import dataclass

@dataclass
class TestDataClass:
    name: str
    obj: str
    obj_list: list[str]
    
n = [{
    'name': 'test0',
    'obj': 'testObject0',
    'obj_list': ['testlist0_0', 'testlist0_1'],
},{
    'name': 'test1',
    'obj': 'testObject1',
    'obj_list': ['testlist1_0', 'testlist1_1'],
}]

t_class_unpacked = [TestDataClass(**i) for i in n]
print(t_class_unpacked)
```

### Nesting

* Never nest more than 3 levels.

### Conditionals

* Prefer trinary expressions:
    * `x = 5 if y > 2 else 3`
* Use implicit evaluations:
    * Avoid `if x is true:`
    * Use `if x:`
* Prefer `or`
    * Avoid `return f"hello {name if name else 'world'}"`
    * Use `return f"hello {name or 'world'}"`

### Class

* Prefer dataclass over vanilla classes

### Unit Testing

* Greater than 79% coverage.
* Where possible test both happy and sad path.

### Strings

* Avoid % where possible.
    * `"Hello, %s. You are %s." % (name, age)`
* Avoid .format() where possible.
    * `"Hello, {}. You are {}.".format("bob", 25)`
* Use f strings.
    * [f string details](https://cis.bentley.edu/sandbox/wp-content/uploads/Documentation-on-f-strings.pdf)

    ```python
    name = "Micah"
    x = 5
    n = f'x is {x}'
    n1 = f'{name.toupper()} call a function in the string'  # In this case there is no value in the name value being upper case.  It is just a display decision.  Just upper it in the display.
    ```

### __repr__() and __str__()

* Common knowledge has __repr__() for programmers and __str__() for users.  
    * Prefer __repr__().
    * There is rarely a reason to print out a vanilla object.  __repr__() should always be defined.

### Composability

* Policies are the business logic.
    * Code that is directly responsible for solving business needs.
* Mechanisms are the pieces of code that provide *HOW* you will enact policies.
* Imagine a restaurant.
    * Policies are the recipes.
    * Mechanisms are how you make the recipes.
* Linking unrelated polices results in dependencies and spaghetti code.
* Separate Policies from Mechanisms.
* Code sections should be:
    * Small
    * Discrete
    * Mostly independent from Business logic.
* For logging, the `Log` module is the mechanism, the code calling the `Log` module is the policy.

#### Prefer composition to inheritance

* Inheritance (Is-a relationship) can give rise to poor entaglement and complex inheritance structure.

```python
# A car IS-A vehicle.
class Vehicle(object):
    def __init__(self, name: str, speed: int):
        self.name = name
        self.speed = speed

    def go():
        pass

class Car(Vehicle):
    def __init__(self, name: str, speed: int):
        super().__init__(name, speed)
        print(f'I have {4} wheels')
```

* Composition (HAS-A relationship): Preferred.

```python
# A car has a wheelbase and an engine.
class WheelBase():
    def __init__(self, number_of_wheels: int):
        self.number_of_wheels = number_of_wheels

class Engine():
    def __init__(self, horsepower: int):
        self.horsepower = horsepower

class Car():
    def __init__(self, name:str, engine: Engine, wheelbase: WheelBase):
        self.name = name
        self.engine = engine
        self.wheelbase = wheelbase

    def DriveCar(self):
        print(f'{self.wheelbase.number_of_wheels} wheels driving a car at {(self.engine.horsepower * speed_coefficient)/ 4}')

```

#### Composing Algorithms

* Separate policy and mechanisms.

### Meta programming

* Prefer protocols to ABC
    * Abstract classes represent an interface.
    * Concrete classes implement abc's.
* anything subclassing another class or adhering to a protocol is a subclass which means it must uphold the contract of the parent type.
    * If that contract is just about attributes, use a protocol.
    * If that contract is attributes AND behaviors, consider ABC.
* Use composite protocols (protocols made up of other protocols) where required.

```python
# Rather than
StandardLunchEntry = Union[Splittable, Shareable, Substitutable, PickUppable]
# Use this
class StandardLunchEntry(Splittable, Shareable, Substitutable, PickUppable, Protocol):
    pass
```

* Where appropriate, use enums.

```python
class ImperialMeasure(Enum):
    OUNCE = 1
    POUND = 16
    QUART = 32
    GALLON = 128
    TEASPOON = auto()
    TABLESPOON = auto()
    CUP = auto()

@dataclass(frozen=True)
class Ingredient:
    name: str
    amount: float = 1
    units: ImperialMeasure = ImperialMeasure.CUP
```

### Functional

* functools is your friend.

```python
from typing import Callable
def do_twice(func: Callable, *args, **kwargs):
    func(*args, **kwargs)
    func(*args, **kwargs)
```

## Pattern Examples

### Observer

```python


## Filename: subscriber.py -or- observer.py
from abc import ABCMeta, abstractmethod

class Subscriber(metaclass=ABCMeta):
    
    @abstractmethod
    def update(self):
        pass

class SMSSubscriber:
    def __init__(self, publisher):
        self.publisher = publisher
        self.publisher.attach(self)
    
    def update(self):
        print(type(self).__name__, self.publisher.getNews())
    
class EmailSubscriber:
    def __init__(self, publisher):
        self.publisher = publisher
        self.publisher.attach(self)
    
    def update(self):
        print(type(self).__name__, self.publisher.getNews())
    
class AnyOtherSubscriber:
    def __init__(self, publisher):
        self.publisher = publisher
        self.publisher.attach(self)
    
    def update(self):
        print(type(self).__name__, self.publisher.getNews())

## Filename: main.py

if __name__ == '__main__':
    news_publisher = NewsPublisher()

    for Subscribers in [SMSSubscriber, EmailSubscriber, AnyOtherSubscriber]:
        Subscribers(news_publisher)
    print("\nSubscribers:", news_publisher.subscribers())

    news_publisher.addNews('Hello World!')
    news_publisher.notifySubscribers()

    print("\nDetached:", type(news_publisher.detach()).__name__)
    print("\nSubscribers:", news_publisher.subscribers())

    news_publisher.addNews('My second news!')
    news_publisher.notifySubscribers()
```