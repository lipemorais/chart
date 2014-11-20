# -*- coding: utf-8 -*-

from django.views.generic import TemplateView
from datetime import date
import requests


class ChartView(TemplateView):
    template_name = 'index.html'

    def get_context_data(self):
        context = {}
        path = 'http://jsonrates.com/historical/?'
        rates_list = []
        days_list = '['

        currency = self.request.GET.get('currency', 'USD')
        currency = currency.upper()
        from_currency = 'from=' + currency
        to_currency = 'to=BRL'

        today = date.today()
        one_week_ago = date(today.year, today.month, today.day - 7)
        date_end = 'dateEnd=' + today.strftime('%Y-%m-%d')
        date_start = 'dateStart=' + one_week_ago.strftime('%Y-%m-%d')

        url = path + from_currency + '&' + to_currency + '&' + date_start + '&' + date_end
        response = requests.get(url)
        context = response.json()
        for key, value in context['rates'].iteritems():
            days_list += '"' + key + '",'
            rates_list.append(value['rate'])
        days_list += ']'

        context['days_list'] = days_list
        context['rates_list'] = rates_list
        return context
