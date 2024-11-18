current_branch = 1.0.0

build_images:
	@docker build -t wsl-spark:$(current_branch) 				./docker/customized/spark
	@docker build -t wsl-spark-notebooks:$(current_branch) 	./docker/customized/notebook
	@docker build -t wsl-spark-apps:$(current_branch) 		./docker/app_layer/spark_jobs
	@docker build -t wsl-python-apps:$(current_branch) 		./docker/app_layer/python_jobs


deploy_services:
	@docker compose -f services/lakehouse.yml up -d --build
	@docker compose -f services/processing.yml up -d --build
	@docker compose -f services/orchestration.yml up -d --build
	@docker compose -f services/applications.yml up -d --build
	# @docker compose -f services/monitoring.yml up -d --build

stop_services:
	@docker compose -f services/lakehouse.yml down
	@docker compose -f services/processing.yml down
	@docker compose -f services/orchestration.yml down
	@docker compose -f services/applications.yml down
	# @docker compose -f services/monitoring.yml down

watch_services:
	@watch docker compose -f services/lakehouse.yml ps