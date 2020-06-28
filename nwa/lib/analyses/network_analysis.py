"""Universal breadth first search graph traversal crawler module.

  Typical usage example:

  crawler = UniversalBfsCrawler(seeds=["http://example.com"])
  crawler.crawl()
"""
from typing import Any

from nwa.lib.base_analyser import BaseAnalyser


class NetworkAnalyser(BaseAnalyser):
    """
    Initialise network analyser.
    """

    def __init__(self, data: Any = None, output: str = ""):
        super(NetworkAnalyser, self).__init__()
        self.name = "network-analysis"
        self.output = output
