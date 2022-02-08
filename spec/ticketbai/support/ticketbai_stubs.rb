def register_ticketbai_stubs
  stub_request(:post, Ticketbai::Api::Request::TEST_PRESENTATION_ENDPOINT)
    .with(
      headers: {
        "Content-Type" => "application/octet-stream",
        "Content-Encoding" => "gzip",
        "eus-bizkaia-n3-version" => "1.0",
        "eus-bizkaia-n3-content-type" => "application/xml",
        "eus-bizkaia-n3-data" => "{\"con\":\"LROE\",\"apa\":\"1.1\",\"inte\":{\"nif\":\"B45454544\",\"nrs\":\"test\"},\"drs\":{\"mode\":\"240\",\"ejer\":\"2022\"}}"
      }
    )
    .to_return(
      status: 200,
      body: "",
      headers: {
        "eus-bizkaia-n3-tipo-respuesta" => "Correcto",
        "eus-bizkaia-n3-identificativo" => "1455634",
        "eus-bizkaia-n3-mensaje-respuesta" => "El mensaje de respuesta"
      }
    )
end
