from django.views.generic import TemplateView


class ChartView(TemplateView):
    template_name = 'index.html'

    def get_context_data(self):
        pass
