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
run_rabbit_mq_migration:
		docker exec -it rabbitmq_scm sh -c '\
			rabbitmqadmin declare exchange --vhost=/ name=logger type=direct -u user -p 12345;\
			rabbitmqadmin declare queue name=info durable=false -u user -p 12345;\
			rabbitmqadmin declare queue name=error durable=false -u user -p 12345;\
			rabbitmqadmin declare queue name=exception durable=false -u user -p 12345;\
			rabbitmqadmin declare binding source=logger destination_type=queue destination=info routing_key=info -u user -p 12345;\
			rabbitmqadmin declare binding source=logger destination_type=queue destination=error routing_key=error -u user -p 12345;\
			rabbitmqadmin declare binding source=logger destination_type=queue destination=exception routing_key=exception -u user -p 12345;\
			rabbitmqadmin declare exchange --vhost=/ name=notifier type=direct -u user -p 12345;\
			rabbitmqadmin declare queue name=users durable=false -u user -p 12345;\
			rabbitmqadmin declare queue name=admins durable=false -u user -p 12345;\
			rabbitmqadmin declare binding source=notifier destination_type=queue destination=users routing_key=users -u user -p 12345;\
			rabbitmqadmin declare binding source=notifier destination_type=queue destination=admins routing_key=admins -u user -p 12345;\
			rabbitmqadmin declare exchange --vhost=/ name=content_chane type=direct -u user -p 12345;\
			rabbitmqadmin declare queue name=device durable=false -u user -p 12345;\
			rabbitmqadmin declare binding source=content_chane destination_type=queue destination=device routing_key=device -u user -p 12345;\
			rabbitmqadmin declare exchange --vhost=/ name=api type=direct -u user -p 12345;\
			rabbitmqadmin declare queue name=admin_panel durable=false -u user -p 12345;\
			rabbitmqadmin declare binding source=api destination=admin_panel destination_type=queue	routing_key=admin_panel -u user -p 12345;'
run_postfix:
	docker run --network host --rm -d --name postfix -p "25:25" -e SMTP_SERVER=smtp.bar.com -e SMTP_USERNAME=user -e SMTP_PASSWORD=12345 -e SERVER_HOSTNAME=dev.scm.com juanluisbaptiste/postfix
