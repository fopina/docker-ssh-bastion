test:
	docker build -t x .
	echo "start sshd on port 22221"
	docker run --rm --name test-ssh-bastion --volume test-ssh-bastion-data:/data -p22221:22 x

clean:
	docker volume rm test-ssh-bastion-data
