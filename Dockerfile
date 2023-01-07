FROM openjdk-11-jdk 
LABEL author="naveen"
COPY /home/devops/node/workspace/spc/target/spring-petclinic-2.7.3.jar /spring-petclinic-2.7.3.jar
EXPOSE 8080
CMD ["java", "-jar", "spring-petclinic-2.7.3.jar"]