all: start

help:
	@echo 'USO: make <target>'
	@echo '-------'
	@echo 'Targets'
	@echo '-------'
	@echo '    start .................................. levanta o servidor do django'
	@echo '    run   .................................. levanta o servidor do django'
	@echo '    find_pdb ............................... procura PDBs no código'
	@echo '    requirements ........................... instala ou atualiza os pacotes usando o requirements.txt'
	@echo '    delpyc ................................. apaga pyc e arquivos desnecessários'
	@echo '    setup .................................. faz o setup do projeto'
	@echo '    create-env ............................. cria a virtualenv chart-env'
	@echo '    clean_up ............................... apaga a virtualenv chart-env'


setup:create-env requirements delpyc start

create-env:
	@echo '=============================================================='
	@echo 'Criando a env chart-env'
	@echo '=============================================================='
	@virtualenv chart-env
	@cd chart-env; source bin/activate

requirements:
	@echo '=============================================================='
	@echo 'Instalando requirements'
	@echo '=============================================================='
	@pip install -r requirements.txt

start: delpyc
	@echo '=============================================================='
	@echo 'Iniciando o servidor do django'
	@echo '=============================================================='
	@python manage.py runserver 0.0.0.0:8765

run: start

delpyc:
	@find . -name "*.pyc" -delete
	@rm -rf build/ dist/ *.egg-info/

find_pdb:
	@result=`grep -r "pdb" * | grep -v "#" | cut -d :  -f 1 | sort | uniq | grep ".py$$"`; if [ -z "$$result" ]; then exit 0; else echo 'ATENCAO!!!! Existe(m) arquivo(s) com pdb: '; for filename in $$result; do echo $$filename; done; exit 1; fi

shell:delpyc
	@python ./manage.py shell

clean_up:
	@rm -rf chart-env

unit:delpyc
	@python manage.py test chart_challenge/tests/unit/ --verbosity=3

integration:delpyc
	@python manage.py test chart_challenge/tests/unit/ --verbosity=3

acceptance:delpyc
	@python manage.py test chart_challenge/tests/acceptance/ --verbosity=3

test:delpyc unit integration acceptance
