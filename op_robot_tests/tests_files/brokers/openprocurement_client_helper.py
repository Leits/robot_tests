from openprocurement_client.client import APIBaseClient, TendersClient
from openprocurement_client.utils import get_tender_id_by_uaid


class AuctionClient(TendersClient):
    def __init__(self, key,
             host_url="https://api-sandbox.openprocurement.org",
             api_version='0.11',
             params=None):
        print AuctionClient.__mro__[2].__init__(self, key, host_url,api_version, "auctions", params)

def prepare_api_wrapper(key, host_url, api_version):
    return AuctionClient(key, host_url, api_version)
