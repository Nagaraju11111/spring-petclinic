FROM maven:3.8.6-openjdk-11 as build
LABEL author="naveen"
ARG BRANCH="ppm"
RUN git clone https://github.com/Nagaraju11111/spring-petclinic.git && \
    cd spring-petclinic && \
    git checkout ${BRANCH} && \
    mvn install
#  jar location /spring-petclinic/target/spring-petclinic-2.7.3.jar
#  Building jar: /spring-petclinic/target/spring-petclinic-2.7.3.jar

FROM openjdk:11
LABEL project="petclinic"
LABEL author="devops"
EXPOSE 8080
COPY --from=build /spring-petclinic/target/spring-petclinic-2.7.3.jar /spring-petclinic-2.7.3.jar
CMD ["java", "-jar", "/spring-petclinic-2.7.3.jar"]