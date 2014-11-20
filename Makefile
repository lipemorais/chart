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
	@echo '    create-db .............................. cria o banco de dados'
	@echo '    db-migrate ............................. roda as migrations'
	@echo '    populate-db ............................ popula o banco de dados com um dump'
	@echo '    clean_up ............................... apaga a virtualenv chart-env  e o banco de dados chart'


setup:create-env requirements db-migrate populate-db delpyc start

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

create-db:
	@echo '=============================================================='
	@echo 'Criando o banco de dados'
	@echo '=============================================================='
	@echo 'CREATE DATABASE IF NOT EXISTS chart;'| mysql -u root

db-migrate:create-db
	@echo '=============================================================='
	@echo 'Rodando as migrations'
	@echo '=============================================================='
	@python manage.py migrate

# populate-db:
# 	@echo '=============================================================='
# 	@echo 'Populando o banco de dados'
# 	@echo '=============================================================='
# 	@mysql -u root chart < chart/fixtures/chart_2014-11-12.sql

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
	@echo 'DROP DATABASE IF EXISTS chart;'| mysql -u root
	@rm -rf chart-env

test_integration:delpyc
	@python manage.py test chart/tests/integration/ --verbosity=3

