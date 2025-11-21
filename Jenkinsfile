pipeline{
    agent any

    environment {
        IMAGE_NAME = 'hello'
        CONTAINER_NAME = 'hello-app'
        HARBOR_URL = '填写harbor仓库的地址'
        HARBOR_PROJECT = 'deploy-demo'
        // Docker tag
        TAG = "v1.0.1"
        // Docker 用户名和密码（可以通过 Jenkins 凭据管理）
        DOCKER_USER = 'harbor账号'
        DOCKER_PASS = 'harbor密码'
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
                sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS} ${HARBOR_URL}"
                // 给镜像打标签
                sh "docker tag ${IMAGE_NAME} ${HARBOR_URL}/${HARBOR_PROJECT}/${IMAGE_NAME}:${TAG}"
                // 推送到harbor
                sh "docker push ${HARBOR_URL}/${HARBOR_PROJECT}/${IMAGE_NAME}:${TAG}"
                // 登出
                sh "docker logout ${HARBOR_URL}"
            }
        }
        stage ("远端服务器拉取镜像"){
            steps {
                sh "ssh  用户名@IP地址 'docker login -u ${DOCKER_USER} -p ${DOCKER_PASS} ${HARBOR_URL} '"
                sh "ssh  用户名@IP地址 linlin@124.223.67.129 'docker pull ${HARBOR_URL}/${HARBOR_PROJECT}/${IMAGE_NAME}:${TAG} '"
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
                sh "ssh 用户名@IP地址 'docker run -d --name ${CONTAINER_NAME} -p 18181:8181 ${HARBOR_URL}/${HARBOR_PROJECT}/${IMAGE_NAME}:${TAG} '"
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
