# encoding: utf-8
#    The origination date field consists of the field name "Date" followed
#    by a date-time specification.
# 
# orig-date       =       "Date:" date-time CRLF
# 
#    The origination date specifies the date and time at which the creator
#    of the message indicated that the message was complete and ready to
#    enter the mail delivery system.  For instance, this might be the time
#    that a user pushes the "send" or "submit" button in an application
#    program.  In any case, it is specifically not intended to convey the
#    time that the message is actually transported, but rather the time at
#    which the human or other creator of the message has put the message
#    into its final form, ready for transport.  (For example, a portable
#    computer user who is not connected to a network might queue a message
#    for delivery.  The origination date is intended to contain the date
#    and time that the user queued the message, not the time when the user
#    connected to the network to send the message.)
module Mail
  class DateField < StructuredField
    
  end
end
