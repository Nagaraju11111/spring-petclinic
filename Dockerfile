FROM amazoncorretto:11 
LABEL author="naveen"
LABEL dev="qt"
ADD curl –u majjinagaraju1996@gmail.com:AKCp8nyhkBAZwfNQzhqULnQBbveqeWhVzK4Ks3hRv7Y26X4x5UCfeGNfXqZF1TMtZJMZ3dzsq https://a0fssz9drglcz.jfrog.io/artifactory/naveen-libs-release-local/org/springframework/samples/spring-petclinic/2.7.3/spring-petclinic-2.7.3.jar /spring-petclinic-2.7.3.jar/
EXPOSE 8080
CMD ["java", "-jar", "spring-petclinic-2.7.3.jar"]