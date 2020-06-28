"""base_analyser
"""
import time
from typing import Any


class BaseAnalyser:
    """BaseAnalyser
    """

    def __init__(self):
        self._name = ""
        self._graph = None
        self._output = ""

    @property
    def name(self) -> str:
        """Getter for name attribute.

        If no name is set, use the module's name.

        Returns:
            The value of the name attribute.
        """
        if "".__eq__(self._name):
            return self.__module__.split(".")[-1].replace("_", "-")
        return self._name

    @name.setter
    def name(self, value: str) -> None:
        """Setter for name attribute.

        Args:
            value: The value to set the name attribute.
        """
        self._name = value

    @property
    def graph(self) -> str:
        """Getter for name attribute.

        Returns:
            The network x object of the graph attribute.
        """
        return self._graph

    @graph.setter
    def graph(self, value: Any) -> None:
        """Setter for graph attribute.

        Args:
            value: The network x object to set the graph attribute.
        """
        self._graph = value

    @property
    def output(self) -> str:
        """Getter for output attribute.

        If no output is set, use a datetime stamp.

        Returns:
            The value of the output attribute.
        """
        if "".__eq__(self._output):
            return time.strftime("%Y%m%d-%H%M%S")
        return self._output

    @output.setter
    def output(self, value: str) -> None:
        """Setter for output attribute.

        Args:
            value: The value to set the output attribute.
        """
        self._output = value

    def _parse_graph(self, data: Any = None) -> Any:
        """Parsing function to construct graph.

        Args:
            eg: eg.

        Raises:
            NotImplementedError: If this method is used but not
                defined in the subcommand class.
        """
        raise NotImplementedError(
            f"Private Method: _parse_graph is undefined for analyser {self.name}"
        )

    def analyse(self):
        """The lib entrypoint command.

        Raises:
            NotImplementedError: If this method is used but not
                defined in the subcommand class.
        """
        raise NotImplementedError(
            f"Method: analyse is undefined for analyser {self.name}"
        )
