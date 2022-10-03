function handler(event) {
    var request = event.request;
    var redirectUrl = request.querystring.redirectUrl;

    if (redirectUrl && redirectUrl.value) {
        var response = {
            statusCode: 302,
            statusDescription: 'Found',
            headers: {
                location: {
                    value: "https://" + redirectUrl.value
                }
            }
        }
        return response; // no futher processing needed
    }

    return request; 
}