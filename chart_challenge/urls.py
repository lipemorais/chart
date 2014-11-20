from django.conf.urls import patterns, url
from chart_challenge.views import ChartView

urlpatterns = patterns('',
    url(r'^$', ChartView.as_view(), name='chart'),
)
