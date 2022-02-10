def register_api_correct_stub
  stub_request(:post, Ticketbai::Api::Request::TEST_PRESENTATION_ENDPOINT)
    .with(
      headers: {
        "Content-Type" => "application/octet-stream",
        "Content-Encoding" => "gzip",
        "eus-bizkaia-n3-version" => "1.0",
        "eus-bizkaia-n3-content-type" => "application/xml",
        "eus-bizkaia-n3-data" => "{\"con\":\"LROE\",\"apa\":\"1.1\",\"inte\":{\"nif\":\"B45454544\",\"nrs\":\"test\"},\"drs\":{\"mode\":\"240\",\"ejer\":\"2022\"}}"
      },
      body: {}
    )
    .to_return(
      status: 200,
      body: '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <ns2:LROEPJ240FacturasEmitidasConSGAltaRespuesta xmlns:ns2="https://www.batuz.eus/fitxategiak/batuz/LROE/esquemas/LROE_PJ_240_1_1_FacturasEmitidas_ConSG_AltaRespuesta_V1_0_1.xsd">
          <Cabecera>
              <Modelo>240</Modelo>
              <Capitulo>1</Capitulo>
              <Subcapitulo>1.1</Subcapitulo>
              <Operacion>A00</Operacion>
              <Version>1.0</Version>
              <Ejercicio>2022</Ejercicio>
              <ObligadoTributario>
                  <NIF>A99999999</NIF>
                  <ApellidosNombreRazonSocial>XXXXXXXXXX</ApellidosNombreRazonSocial>
              </ObligadoTributario>
          </Cabecera>
          <DatosPresentacion>
              <FechaPresentacion>10-02-2022 19:19:22</FechaPresentacion>
              <NIFPresentador>S7836107H</NIFPresentador>
          </DatosPresentacion>
          <Registros>
              <Registro>
                  <Identificador>
                      <IDFactura>
                          <NumFactura>2022/BCGF00011</NumFactura>
                          <FechaExpedicionFactura>10-02-2022</FechaExpedicionFactura>
                      </IDFactura>
                  </Identificador>
                  <SituacionRegistro>
                      <EstadoRegistro>Correcto</EstadoRegistro>
                  </SituacionRegistro>
              </Registro>
          </Registros>
      </ns2:LROEPJ240FacturasEmitidasConSGAltaRespuesta>
      ',
      headers:{
        "date"=>"Thu, 10 Feb 2022 18:17:31 GMT",
        "server"=>"JBoss-EAP/7",
        "eus-bizkaia-n3-identificativo"=>"6421489",
        "x-powered-by"=>"Undertow/1",
        "eus-bizkaia-n3-codigo-respuesta"=>"",
        "eus-bizkaia-n3-numero-registro"=>"",
        "eus-bizkaia-n3-tipo-respuesta"=>"Correcto",
        "content-type"=>"application/xml;charset=UTF-8",
        "content-length"=>"589",
        "connection"=>"close"
      }
    )
end

def register_api_incorrect_stub
  stub_request(:post, Ticketbai::Api::Request::TEST_PRESENTATION_ENDPOINT)
    .with(
      headers: {
        "Content-Type" => "application/octet-stream",
        "Content-Encoding" => "gzip",
        "eus-bizkaia-n3-version" => "1.0",
        "eus-bizkaia-n3-content-type" => "application/xml",
        "eus-bizkaia-n3-data" => "{\"con\":\"LROE\",\"apa\":\"1.1\",\"inte\":{\"nif\":\"B45454544\",\"nrs\":\"test\"},\"drs\":{\"mode\":\"240\",\"ejer\":\"2022\"}}"
      },
      body: {}
    )
    .to_return(
      status: 200,
      body: '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <ns2:LROEPJ240FacturasEmitidasConSGAltaRespuesta xmlns:ns2="https://www.batuz.eus/fitxategiak/batuz/LROE/esquemas/LROE_PJ_240_1_1_FacturasEmitidas_ConSG_AltaRespuesta_V1_0_1.xsd">
          <Cabecera>
              <Modelo>240</Modelo>
              <Capitulo>1</Capitulo>
              <Subcapitulo>1.1</Subcapitulo>
              <Operacion>A00</Operacion>
              <Version>1.0</Version>
              <Ejercicio>2022</Ejercicio>
              <ObligadoTributario>
                  <NIF>A99999999</NIF>
                  <ApellidosNombreRazonSocial>XXXXXXXXXX</ApellidosNombreRazonSocial>
              </ObligadoTributario>
          </Cabecera>
          <Registros>
              <Registro>
                  <Identificador>
                      <IDFactura>
                          <NumFactura>2022/00001</NumFactura>
                          <FechaExpedicionFactura>02-01-2022</FechaExpedicionFactura>
                      </IDFactura>
                  </Identificador>
                  <SituacionRegistro>
                      <EstadoRegistro>Incorrecto</EstadoRegistro>
                      <CodigoErrorRegistro>B4_2000003</CodigoErrorRegistro>
                      <DescripcionErrorRegistroES>Registro duplicado.</DescripcionErrorRegistroES>
                      <DescripcionErrorRegistroEU>Erregistro bikoiztua.</DescripcionErrorRegistroEU>
                  </SituacionRegistro>
              </Registro>
          </Registros>
      </ns2:LROEPJ240FacturasEmitidasConSGAltaRespuesta>',
      headers:{
        "date"=>"Thu, 10 Feb 2022 19:17:33 GMT",
        "server"=>"JBoss-EAP/7",
        "eus-bizkaia-n3-identificativo"=>"6421611",
        "x-powered-by"=>"Undertow/1",
        "eus-bizkaia-n3-mensaje-respuesta"=>"Todos los registros incluidos en la petici\xF3n son incorrectos.",
        "eus-bizkaia-n3-codigo-respuesta"=>"B4_1000002",
        "eus-bizkaia-n3-numero-registro"=>"",
        "eus-bizkaia-n3-tipo-respuesta"=>"Incorrecto",
        "content-type"=>"application/xml;charset=UTF-8",
        "content-length"=>"601",
        "connection"=>"close"
      }
    )
end

def register_api_partially_correct_stub
  stub_request(:post, Ticketbai::Api::Request::TEST_PRESENTATION_ENDPOINT)
    .with(
      headers: {
        "Content-Type" => "application/octet-stream",
        "Content-Encoding" => "gzip",
        "eus-bizkaia-n3-version" => "1.0",
        "eus-bizkaia-n3-content-type" => "application/xml",
        "eus-bizkaia-n3-data" => "{\"con\":\"LROE\",\"apa\":\"1.1\",\"inte\":{\"nif\":\"B45454544\",\"nrs\":\"test\"},\"drs\":{\"mode\":\"240\",\"ejer\":\"2022\"}}"
      },
      body: {}
    )
    .to_return(
      status: 200,
      body: '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <ns2:LROEPJ240FacturasEmitidasConSGAltaRespuesta xmlns:ns2="https://www.batuz.eus/fitxategiak/batuz/LROE/esquemas/LROE_PJ_240_1_1_FacturasEmitidas_ConSG_AltaRespuesta_V1_0_1.xsd">
          <Cabecera>
              <Modelo>240</Modelo>
              <Capitulo>1</Capitulo>
              <Subcapitulo>1.1</Subcapitulo>
              <Operacion>A00</Operacion>
              <Version>1.0</Version>
              <Ejercicio>2022</Ejercicio>
              <ObligadoTributario>
                  <NIF>A99999999</NIF>
                  <ApellidosNombreRazonSocial>XXXXXXXXXX</ApellidosNombreRazonSocial>
              </ObligadoTributario>
          </Cabecera>
          <DatosPresentacion>
              <FechaPresentacion>10-02-2022 20:37:09</FechaPresentacion>
              <NIFPresentador>S7836107H</NIFPresentador>
          </DatosPresentacion>
          <Registros>
              <Registro>
                  <Identificador>
                      <IDFactura>
                          <SerieFactura></SerieFactura>
                          <NumFactura>2022/00021</NumFactura>
                          <FechaExpedicionFactura>25-01-2022</FechaExpedicionFactura>
                      </IDFactura>
                  </Identificador>
                  <SituacionRegistro>
                      <EstadoRegistro>Incorrecto</EstadoRegistro>
                      <CodigoErrorRegistro>B4_2000011</CodigoErrorRegistro>
                      <DescripcionErrorRegistroES>El NIF tiene un formato erróneo.</DescripcionErrorRegistroES>
                      <DescripcionErrorRegistroEU>IFZren formatua okerra da.</DescripcionErrorRegistroEU>
                  </SituacionRegistro>
              </Registro>
              <Registro>
                  <Identificador>
                      <IDFactura>
                          <NumFactura>2022/TICK00232</NumFactura>
                          <FechaExpedicionFactura>10-02-2022</FechaExpedicionFactura>
                      </IDFactura>
                  </Identificador>
                  <SituacionRegistro>
                      <EstadoRegistro>Correcto</EstadoRegistro>
                  </SituacionRegistro>
              </Registro>
          </Registros>
      </ns2:LROEPJ240FacturasEmitidasConSGAltaRespuesta>',
      headers:{
        "date"=>"Thu, 10 Feb 2022 19:37:09 GMT",
        "server"=>"JBoss-EAP/7",
        "eus-bizkaia-n3-identificativo"=>"6421637",
        "x-powered-by"=>"Undertow/1",
        "eus-bizkaia-n3-mensaje-respuesta"=>"ParcialmenteCorrecto",
        "eus-bizkaia-n3-codigo-respuesta"=>"",
        "eus-bizkaia-n3-numero-registro"=>"",
        "eus-bizkaia-n3-tipo-respuesta"=>"ParcialmenteCorrecto",
        "content-type"=>"application/xml;charset=UTF-8",
        "content-length"=>"726",
        "connection"=>"close"
      }
    )
end
