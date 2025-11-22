pipeline{
    agent any

    environment {
        IMAGE_NAME = 'app'
        CONTAINER_NAME = 'app'
        HARBOR_PROJECT = 'privatestudy'
        // Docker tag
        TAG = "v1.0.1"
        // Docker 用户名和密码（可以通过 Jenkins 凭据管理）
        DOCKER_USER = '18717468846wp'
        DOCKER_PASS = 'dckr_pat_qJvEfqSV5GvQJ_VB42R345tdBtM'
        //
    }
    stages{
        stage("打包镜像"){
            steps {
                echo '开始打包'
                sh 'docker build --no-cache -t ${IMAGE_NAME} -f ./Dockerfile .'
                echo "打包成功"
            }
        }
        stage("推送到harbor"){
            steps {
                // 登录harbor镜像仓库
                sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                // 给镜像打标签
                sh "docker tag ${IMAGE_NAME} ${HARBOR_PROJECT}/${IMAGE_NAME}:${TAG}"
                // 推送到harbor
                sh "docker push ${HARBOR_PROJECT}/${IMAGE_NAME}:${TAG}"
                // 登出
                sh "docker logout"
            }
        }
        stage ("远端服务器拉取镜像"){
            steps {
                sh "ssh wangping@10.15.20.71 'docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}'"
                sh "ssh wangping@10.15.20.71 'docker pull ${HARBOR_PROJECT}/${IMAGE_NAME}:${TAG} '"
            }
        }
        stage("停止远端服务器上的旧容器"){
            steps {
                script{
                    def containerId = sh(script: "docker ps -q -f name=${CONTAINER_NAME}", returnStdout: true).trim()
                     if (containerId) {
                         echo "Found running container with ID: ${containerId}. Stopping and removing it."
                         // stop and remove the old container
                         sh "docker stop ${CONTAINER_NAME}"
                         sh "docker rm ${CONTAINER_NAME}"
                     } else {
                         echo "No running container found with name: ${CONTAINER_NAME}."
                     }
                     echo "Old container stopped and removed."}
            }
        }
        stage("远端服务器启动新容器"){
            steps {
                sh "ssh wangping@10.15.20.71 'docker run -d --name ${CONTAINER_NAME} -p 18181:8181 ${HARBOR_PROJECT}/${IMAGE_NAME}:${TAG} '"
            }
        }
    }
    post{
        always{
            echo 'always say goodbay'
//             sh "docker rmi ${HARBOR_URL}/${HARBOR_PROJECT}/${IMAGE_NAME}:${TAG} || true"
        }
    }
}
