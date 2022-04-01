package funesto.server

import org.springframework.boot.context.properties.ConfigurationPropertiesScan
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.builder.SpringApplicationBuilder

@SpringBootApplication( scanBasePackages = Array( "funesto.server" ) )
@ConfigurationPropertiesScan( Array( "funesto.server.configuration" ) )
class Boot

object Boot {
  def main(args: Array[String] ): Unit = {
    val app = new SpringApplicationBuilder()
      .sources( classOf[Boot] )
      .registerShutdownHook( true )
      .build()
    app.run( args: _* )
  }
}
