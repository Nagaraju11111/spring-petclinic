FROM amazoncorretto:11 
LABEL author="naveen"
LABEL dev="qt"
ADD /home/devops/node/workspace/spring-petclinic/spring-petclinic-2.7.3.jar /spring-petclinic-2.7.3.jar
EXPOSE 8080
CMD ["java", "-jar", "spring-petclinic-2.7.3.jar"]