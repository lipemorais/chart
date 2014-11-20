# -*- coding: utf-8 -*-
from django.core.urlresolvers import reverse, resolve
from django.test import TestCase


class TestIndexURL(TestCase):

    def test_index_url_is_available(self):
        url = reverse(u'chart')
        self.assertEquals(url, u'/')

    def test_name_of_the_url_is_chart(self):
        resolver = resolve(u'/')
        self.assertEquals(resolver.url_name, u'chart')
