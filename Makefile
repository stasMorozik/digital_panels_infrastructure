build_web_dav:
	docker build -f Dockerfile.web.dav ./ -t web_dav
run_web_dav:
	docker run -d --network host --rm --name web_dav -e TZ=Europe/Moscow web_dav
run_db_system_content_manager:
	docker run --network host --rm -d --name db_system_content_manager -e POSTGRES_PASSWORD=12345 -e POSTGRES_DB=system_content_manager -e POSTGRES_USER=db_user -v $(CURDIR)/postgresql/:/tmp -v /src/db_system_content_manager/:/var/lib/postgresql/data -e PGPORT=5437 postgres
run_migration_db_system_content_manager:
	docker exec -it db_system_content_manager sh -c 'psql -d system_content_manager -U db_user --password 12345 -f tmp/schema.sql'
run_rabbit_mq:
	docker run --network host --rm -d --hostname localhost --name rabbitmq_scm -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=12345 rabbitmq:3-management
run_postfix:
	docker run --network host --rm -d --name postfix -p "25:25" -e SMTP_SERVER=smtp.bar.com -e SMTP_USERNAME=user -e SMTP_PASSWORD=12345 -e SERVER_HOSTNAME=dev.scm.com juanluisbaptiste/postfix