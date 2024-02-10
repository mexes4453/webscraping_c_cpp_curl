#include "utils.h"
#include <curl/curl.h>

//size_t  write_chunk(void *data, size_t size, size_t nmemb, void *userdata);
int main(void)
{
    char *url = "https://finance.yahoo.com/quote/UBER/key-statistics?p=UBER";
    CURL *curlHandle;
    CURLcode curlResult;

    curlHandle = curl_easy_init();
    UTILS_ASSERT(curlHandle, "Error! Curl init failed\n");

    /* setup engine prior to contacting server */
    curl_easy_setopt(curlHandle, CURLOPT_URL, url);

    /* contact server */
    curlResult = curl_easy_perform(curlHandle);
    UTILS_ASSERT((curlResult == CURLE_OK), curl_easy_strerror(curlResult));

    /* clean up memory */
    curl_easy_cleanup(curlHandle);

  

    return (0);
}

/*
size_t  write_chunk(void *data, size_t size, size_t nmemb, void *userdata)
{

}
*/