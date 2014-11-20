from django.test import TestCase
import requests


class TestAPI(TestCase):

    def test_api_its_alive(self):
        response = requests.get('http://jsonrates.com/get/?from=USD&to=EUR')
        self.assertEquals(response.status_code, 200)
