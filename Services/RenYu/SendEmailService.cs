using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Drawing;
using System.Net;
using System.Net.Mail;

namespace HotelFuen31.APIs.Services.RenYu
{
    public class SendEmailService
    {
        public void SendEmail(string subject, string body, string toEmail)
        {
            try
            {
                string sender = "kalsarihotel@gmail.com";
                string appPassword = "tuastatfwzzxbhmg";

                SmtpClient smtpClient = new SmtpClient("smtp.gmail.com")
                {
                    Port = 587,
                    Credentials = new NetworkCredential(sender, appPassword),
                    EnableSsl = true
                };

                MailMessage message = new MailMessage()
                {
                    From = new MailAddress(sender),
                    Subject = subject,
                    Body = body,
                    IsBodyHtml = true
                };

                message.To.Add(toEmail);

                smtpClient.Send(message);

            }
            catch (Exception ex) 
            {
               
            }
           
        }
    }
}
