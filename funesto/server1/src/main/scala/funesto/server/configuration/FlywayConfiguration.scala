package funesto.server.configuration

import org.flywaydb.core.Flyway
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Bean
import org.springframework.core.env.Environment

@Configuration
class FlywayConfiguration(val env: Environment ) {
  @Bean( initMethod = "migrate" )
  def flyway(): Flyway =
    new Flyway(
      Flyway
        .configure()
        .baselineOnMigrate( true )
        .dataSource(
          env.getRequiredProperty( "spring.flyway.url" ),
          env.getRequiredProperty( "spring.flyway.user" ),
          env.getRequiredProperty( "spring.flyway.password" )
        )
    )
}