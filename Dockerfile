FROM amazoncorretto:11 
LABEL author="naveen"
LABEL dev="qt"
ADD https://pdpk8s.jfrog.io/artifactory/naveen-libs-release-local/org/springframework/samples/spring-petclinic/2.7.3/spring-petclinic-2.7.3.jar /spring-petclinic-2.7.3.jar
EXPOSE 8080
CMD ["java", "-jar", "spring-petclinic-2.7.3.jar"]