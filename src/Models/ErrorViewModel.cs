namespace ihs_innerloop.Models;

public class ErrorViewModel
{
    public string? RequestId { get; set; }
    public int Test{get; set;}

    public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
}
